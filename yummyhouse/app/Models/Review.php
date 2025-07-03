<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Review extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'restaurant_id',
        'order_id',
        'food_id',
        'product_id',
        'rating',
        'comment',
        'images',
        'is_approved',
        'helpful_count',
        'response_from_restaurant',
        'responded_at'
    ];

    protected $casts = [
        'rating' => 'integer',
        'images' => 'array',
        'is_approved' => 'boolean',
        'helpful_count' => 'integer',
        'responded_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function food()
    {
        return $this->belongsTo(Food::class);
    }


    public function scopeApproved($query)
    {
        return $query->where('is_approved', true);
    }

    public function scopeByRating($query, $rating)
    {
        return $query->where('rating', $rating);
    }

    public function scopeMinRating($query, $minRating)
    {
        return $query->where('rating', '>=', $minRating);
    }

    public function scopeRecent($query, $days = 30)
    {
        return $query->where('created_at', '>=', now()->subDays($days));
    }

    public function scopeWithResponse($query)
    {
        return $query->whereNotNull('response_from_restaurant');
    }

    public function getItemAttribute()
    {
        return $this->food ?: $this->product;
    }

    public function getItemNameAttribute()
    {
        $item = $this->getItemAttribute();
        return $item ? $item->name : 'General Review';
    }

    public function getRatingStarsAttribute()
    {
        $stars = '';
        for ($i = 1; $i <= 5; $i++) {
            $stars .= $i <= $this->rating ? '★' : '☆';
        }
        return $stars;
    }

    public function hasResponse()
    {
        return !empty($this->response_from_restaurant);
    }

    public function getTimeAgoAttribute()
    {
        return $this->created_at->diffForHumans();
    }
}
