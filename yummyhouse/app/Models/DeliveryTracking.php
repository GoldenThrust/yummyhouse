<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class DeliveryTracking extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_id',
        'delivery_person_id',
        'status',
        'estimated_delivery_time',
        'actual_delivery_time',
        'pickup_time',
        'current_latitude',
        'current_longitude',
        'longitude',
        'latitude',
        'notes'
    ];

    protected $casts = [
        'estimated_delivery_time' => 'datetime',
        'actual_delivery_time' => 'datetime',
        'pickup_time' => 'datetime',
        'current_latitude' => 'decimal:8',
        'current_longitude' => 'decimal:8',
        'longitude' => 'array',
        'latitude' => 'array',
    ];

    public const STATUS_ASSIGNED = 'assigned';
    public const STATUS_PICKED_UP = 'picked_up';
    public const STATUS_ON_THE_WAY = 'on_the_way';
    public const STATUS_DELIVERED = 'delivered';
    public const STATUS_CANCELLED = 'cancelled';

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function deliveryPerson()
    {
        return $this->belongsTo(User::class, 'delivery_person_id');
    }

    public function scopeActive($query)
    {
        return $query->whereIn('status', [
            self::STATUS_ASSIGNED,
            self::STATUS_PICKED_UP,
            self::STATUS_ON_THE_WAY
        ]);
    }

    public function isDelivered()
    {
        return $this->status === self::STATUS_DELIVERED;
    }

    public function isCancelled()
    {
        return $this->status === self::STATUS_CANCELLED;
    }
}
