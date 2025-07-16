<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Restaurant extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'description',
        'image_url',
        'banner_url',
        'phone',
        'email',
        'website',
        'address',
        'city',
        'state',
        'postal_code',
        'country',
        'latitude',
        'longitude',
        'cuisine_type',
        'price_range',
        'rating',
        'review_count',
        'delivery_time',
        'minimum_order',
        'delivery_fee',
        'is_open',
        'is_active',
        'opening_hours',
        'delivery_radius',
        'featured',
        'delivery_price',
        'delivery_price_type',
    ];

    protected $casts = [
        'latitude' => 'decimal:8',
        'longitude' => 'decimal:8',
        'rating' => 'decimal:2',
        'review_count' => 'integer',
        'delivery_time' => 'integer',
        'minimum_order' => 'decimal:2',
        'delivery_fee' => 'decimal:2',
        'delivery_radius' => 'decimal:2',
        'is_open' => 'boolean',
        'is_active' => 'boolean',
        'featured' => 'boolean',
        'opening_hours' => 'array',
        'cuisine_type' => 'array',
    ];

    public function owner()
    {
        return $this->belongsTo(User::class, 'user_id');
    }

    public function foods()
    {
        return $this->hasMany(Food::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function coupons()
    {
        return $this->hasMany(Coupon::class);
    }

    public function staff()
    {
        return $this->hasMany(RestaurantStaff::class);
    }

    public function activeStaff()
    {
        return $this->hasMany(RestaurantStaff::class)->where('status', 'active');
    }

    public function managers()
    {
        return $this->hasMany(RestaurantStaff::class)->where('role', 'manager')->where('status', 'active');
    }

    public function deliveryStaff()
    {
        return $this->hasMany(RestaurantStaff::class)->where('role', 'delivery_person')->where('status', 'active');
    }

    public function availableDeliveryStaff()
    {
        return $this->deliveryStaff()->whereHas('user', function($query) {
            $query->whereHas('vehicleInfo', function($q) {
                $q->where('is_verified', true);
            });
        });
    }

    /**
     * Get an available delivery person for an order.
     */
    public function getAvailableDeliveryPerson()
    {
        return $this->staff()
                   ->availableDeliveryPersons()
                   ->with(['user', 'user.vehicleInfo'])
                   ->first();
    }

    /**
     * Count available delivery persons.
     */
    public function availableDeliveryPersonsCount(): int
    {
        return $this->staff()
                   ->availableDeliveryPersons()
                   ->count();
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }

    public function scopeOpen($query)
    {
        return $query->where('is_open', true);
    }

    public function scopeFeatured($query)
    {
        return $query->where('featured', true);
    }

    public function scopeByPriceRange($query, $priceRange)
    {
        return $query->where('price_range', $priceRange);
    }

    public function scopeWithinRadius($query, $latitude, $longitude, $radius = 10)
    {
        return $query->selectRaw("
            *, 
            (6371 * acos(cos(radians(?)) * cos(radians(latitude)) * cos(radians(longitude) - radians(?)) + sin(radians(?)) * sin(radians(latitude)))) AS distance
        ", [$latitude, $longitude, $latitude])
            ->having('distance', '<=', $radius)
            ->orderBy('distance');
    }

    public function getDistanceFromAttribute($latitude, $longitude)
    {
        if (!$this->latitude || !$this->longitude) {
            return null;
        }

        $earthRadius = 6371; // Earth's radius in kilometers

        $lat1 = floatval($this->latitude);
        $lon1 = floatval($this->longitude);
        $lat2 = floatval($latitude);
        $lon2 = floatval($longitude);

        $latDelta = deg2rad($lat2 - $lat1);
        $lonDelta = deg2rad($lon2 - $lon1);

        $a = sin($latDelta / 2) * sin($latDelta / 2) +
            cos(deg2rad($lat1)) * cos(deg2rad($lat2)) *
            sin($lonDelta / 2) * sin($lonDelta / 2);

        $c = 2 * atan2(sqrt($a), sqrt(1 - $a));

        return round($earthRadius * $c, 2);
    }

    public function isOpenNow()
    {
        if (!$this->is_open || !$this->opening_hours) {
            return false;
        }

        $today = strtolower(now()->format('l'));
        $currentTime = now()->format('H:i');

        if (!isset($this->opening_hours[$today])) {
            return false;
        }

        $hours = $this->opening_hours[$today];

        if ($hours['closed']) {
            return false;
        }

        return $currentTime >= $hours['open'] && $currentTime <= $hours['close'];
    }

    public function getAverageRatingAttribute()
    {
        return $this->reviews()->avg('rating') ?? 0;
    }

    public function getTotalReviewsAttribute()
    {
        return $this->reviews()->count();
    }
}
