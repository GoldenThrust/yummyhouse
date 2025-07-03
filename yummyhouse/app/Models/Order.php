<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Order extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'restaurant_id',
        'address_id',
        'order_number',
        'status',
        'subtotal',
        'tax_amount',
        'delivery_fee',
        'discount_amount',
        'total_amount',
        'payment_status',
        'payment_method',
        'coupon_id',
        'estimated_delivery_time',
        'actual_delivery_time',
        'special_instructions',
        'cancelled_reason',
        'cancelled_at'
    ];

    protected $casts = [
        'subtotal' => 'decimal:2',
        'tax_amount' => 'decimal:2',
        'delivery_fee' => 'decimal:2',
        'discount_amount' => 'decimal:2',
        'total_amount' => 'decimal:2',
        'estimated_delivery_time' => 'datetime',
        'actual_delivery_time' => 'datetime',
        'cancelled_at' => 'datetime',
    ];

    public const STATUS_PENDING = 'pending';
    public const STATUS_CONFIRMED = 'confirmed';
    public const STATUS_PREPARING = 'preparing';
    public const STATUS_READY = 'ready';
    public const STATUS_OUT_FOR_DELIVERY = 'out_for_delivery';
    public const STATUS_DELIVERED = 'delivered';
    public const STATUS_CANCELLED = 'cancelled';

    public const PAYMENT_STATUS_PENDING = 'pending';
    public const PAYMENT_STATUS_PAID = 'paid';
    public const PAYMENT_STATUS_FAILED = 'failed';
    public const PAYMENT_STATUS_REFUNDED = 'refunded';

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function restaurant()
    {
        return $this->belongsTo(Restaurant::class);
    }

    public function address()
    {
        return $this->belongsTo(Address::class);
    }

    public function orderItems()
    {
        return $this->hasMany(OrderItem::class);
    }

    public function payment()
    {
        return $this->hasOne(Payment::class);
    }

    public function deliveryTracking()
    {
        return $this->hasOne(DeliveryTracking::class);
    }

    public function coupon()
    {
        return $this->belongsTo(Coupon::class);
    }

    public function review()
    {
        return $this->hasOne(Review::class);
    }

    public function scopePending($query)
    {
        return $query->where('status', self::STATUS_PENDING);
    }

    public function scopeActive($query)
    {
        return $query->whereIn('status', [
            self::STATUS_PENDING,
            self::STATUS_CONFIRMED,
            self::STATUS_PREPARING,
            self::STATUS_READY,
            self::STATUS_OUT_FOR_DELIVERY
        ]);
    }

    public function scopeCompleted($query)
    {
        return $query->where('status', self::STATUS_DELIVERED);
    }

    public function isPaid()
    {
        return $this->payment_status === self::PAYMENT_STATUS_PAID;
    }

    public function canBeCancelled()
    {
        return in_array($this->status, [
            self::STATUS_PENDING,
            self::STATUS_CONFIRMED
        ]);
    }

    public function getStatusColorAttribute()
    {
        $colors = [
            self::STATUS_PENDING => 'warning',
            self::STATUS_CONFIRMED => 'info',
            self::STATUS_PREPARING => 'primary',
            self::STATUS_READY => 'success',
            self::STATUS_OUT_FOR_DELIVERY => 'primary',
            self::STATUS_DELIVERED => 'success',
            self::STATUS_CANCELLED => 'danger',
        ];

        return $colors[$this->status] ?? 'secondary';
    }
}
