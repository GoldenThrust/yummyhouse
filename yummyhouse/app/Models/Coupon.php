<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Carbon\Carbon;

class Coupon extends Model
{
    use HasFactory;

    protected $fillable = [
        'code',
        'name',
        'description',
        'type', // 'percentage', 'fixed_amount', 'free_delivery'
        'value',
        'minimum_order_amount',
        'maximum_discount_amount',
        'usage_limit',
        'usage_limit_per_user',
        'used_count',
        'valid_from',
        'valid_until',
        'is_active',
        'restaurant_id' // null for global coupons
    ];

    protected $casts = [
        'value' => 'decimal:2',
        'minimum_order_amount' => 'decimal:2',
        'maximum_discount_amount' => 'decimal:2',
        'usage_limit' => 'integer',
        'usage_limit_per_user' => 'integer',
        'used_count' => 'integer',
        'valid_from' => 'datetime',
        'valid_until' => 'datetime',
        'is_active' => 'boolean',
    ];

    public function users()
    {
        return $this->belongsToMany(User::class, 'user_coupons')
                    ->withPivot('used_at')
                    ->withTimestamps();
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function userCoupons()
    {
        return $this->hasMany(UserCoupon::class);
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true)
                    ->where('valid_from', '<=', now())
                    ->where('valid_until', '>=', now());
    }

    public function scopeAvailable($query)
    {
        return $query->where('is_active', true)
                    ->where('valid_from', '<=', now())
                    ->where('valid_until', '>=', now())
                    ->where(function($q) {
                        $q->whereNull('usage_limit')
                          ->orWhereRaw('used_count < usage_limit');
                    });
    }

    public function isValid()
    {
        return $this->is_active && 
               $this->valid_from <= now() && 
               $this->valid_until >= now() &&
               ($this->usage_limit === null || $this->used_count < $this->usage_limit);
    }

    public function canBeUsedBy(User $user)
    {
        if (!$this->isValid()) {
            return false;
        }

        if ($this->usage_limit_per_user === null) {
            return true;
        }

        $userUsageCount = $this->userCoupons()
                              ->where('user_id', $user->id)
                              ->whereNotNull('used_at')
                              ->count();

        return $userUsageCount < $this->usage_limit_per_user;
    }
}
