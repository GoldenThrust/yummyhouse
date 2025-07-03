<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class UserCoupon extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'coupon_id',
        'used_at',
        'order_id'
    ];

    protected $casts = [
        'used_at' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function coupon()
    {
        return $this->belongsTo(Coupon::class);
    }

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function scopeUsed($query)
    {
        return $query->whereNotNull('used_at');
    }

    public function scopeUnused($query)
    {
        return $query->whereNull('used_at');
    }

    public function scopeValid($query)
    {
        return $query->whereNull('used_at')
                    ->whereHas('coupon', function($q) {
                        $q->where('is_active', true)
                          ->where('valid_from', '<=', now())
                          ->where('valid_until', '>=', now());
                    });
    }

    public function isUsed()
    {
        return !is_null($this->used_at);
    }

    public function isValid()
    {
        if ($this->isUsed() || !$this->coupon) {
            return false;
        }

        if (!$this->coupon->isValid()) {
            return false;
        }

        // Load the user relationship if not already loaded
        $user = $this->user instanceof User ? $this->user : $this->user()->first();
        
        return $user && $this->coupon->canBeUsedBy($user);
    }

    public function markAsUsed($orderId = null)
    {
        $this->update([
            'used_at' => now(),
            'order_id' => $orderId
        ]);

        // Increment the coupon usage count
        if ($this->coupon) {
            $this->coupon->increment('used_count');
        }

        return $this;
    }
}
