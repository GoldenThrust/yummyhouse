<?php

namespace App\Models;

use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;
use App\Notifications\ResetPasswordNotification;

class User extends Authenticatable implements MustVerifyEmail
{
    /** @use HasFactory<\Database\Factories\UserFactory> */
    use HasApiTokens, HasFactory, Notifiable;

    public const ROLE = ['customer', 'admin', 'restaurant_owner', 'delivery_persons'];

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'phone_number',
        'role',
    ];

    
    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'email_verified_at' => 'datetime',
            'password' => 'hashed',
        ];
    }


    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];


    public function addresses()
    {
        return $this->hasMany(Address::class);
    }

    public function orders()
    {
        return $this->hasMany(Order::class);
    }

    public function reviews()
    {
        return $this->hasMany(Review::class);
    }

    public function restaurants()
    {
        return $this->hasMany(Restaurant::class);
    }

    public function coupons()
    {
        return $this->belongsToMany(Coupon::class, 'user_coupons')->withPivot('used_at')->withTimestamps();
    }

    public function vehicleInfo()
    {
        return $this->hasOne(VehicleInfo::class);
    }

    public function deliveryTrackings()
    {
        return $this->hasMany(DeliveryTracking::class, 'delivery_person_id');
    }

    public function deliveredOrders()
    {
        return $this->hasManyThrough(Order::class, DeliveryTracking::class, 'delivery_person_id', 'id', 'id', 'order_id');
    }

    /**
     * Send a password reset notification to the user.
     *
     * @param  string  $token
     */
    public function sendPasswordResetNotification($token): void
    {
        $url =  env('MOBILE_URL') . '/reset-password?token=' . $token;

        $this->notify(new ResetPasswordNotification($url));
    }

    // Scopes
    public function scopeCustomers($query)
    {
        return $query->where('role', 'customer');
    }

    public function scopeRestaurantOwners($query)
    {
        return $query->where('role', 'restaurant_owner');
    }

    public function scopeDeliveryPersons($query)
    {
        return $query->where('role', 'delivery_persons');
    }

    public function scopeAdmins($query)
    {
        return $query->where('role', 'admin');
    }

    public function scopeVerified($query)
    {
        return $query->whereNotNull('email_verified_at');
    }

    // Helper methods
    public function isCustomer()
    {
        return $this->role === 'customer';
    }

    public function isRestaurantOwner()
    {
        return $this->role === 'restaurant_owner';
    }

    public function isDeliveryPerson()
    {
        return $this->role === 'delivery_persons';
    }

    public function isAdmin()
    {
        return $this->role === 'admin';
    }

    public function canDeliverOrders()
    {
        return $this->isDeliveryPerson() && 
               $this->vehicleInfo && 
               $this->vehicleInfo->canDeliver();
    }

    public function hasVerifiedVehicle()
    {
        return $this->vehicleInfo && $this->vehicleInfo->is_verified;
    }

    public function getFullNameAttribute()
    {
        return $this->name;
    }

    public function getDisplayRoleAttribute()
    {
        $roles = [
            'customer' => 'Customer',
            'admin' => 'Administrator',
            'restaurant_owner' => 'Restaurant Owner',
            'delivery_persons' => 'Delivery Person'
        ];

        return $roles[$this->role] ?? ucfirst($this->role);
    }
}
