<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Payment extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_id',
        'payment_method',
        'payment_gateway',
        'transaction_id',
        'amount',
        'currency',
        'status',
        'gateway_response',
        'processed_at',
        'refunded_at',
        'refund_amount',
        'failure_reason'
    ];

    protected $casts = [
        'amount' => 'decimal:2',
        'refund_amount' => 'decimal:2',
        'gateway_response' => 'array',
        'processed_at' => 'datetime',
        'refunded_at' => 'datetime',
    ];

    public const STATUS_PENDING = 'pending';
    public const STATUS_PROCESSING = 'processing';
    public const STATUS_COMPLETED = 'completed';
    public const STATUS_FAILED = 'failed';
    public const STATUS_CANCELLED = 'cancelled';
    public const STATUS_REFUNDED = 'refunded';
    public const STATUS_PARTIALLY_REFUNDED = 'partially_refunded';

    public const METHOD_CREDIT_CARD = 'credit_card';
    public const METHOD_DEBIT_CARD = 'debit_card';
    public const METHOD_PAYPAL = 'paypal';
    public const METHOD_CASH_ON_DELIVERY = 'cash_on_delivery';
    public const METHOD_WALLET = 'wallet';
    public const METHOD_BANK_TRANSFER = 'bank_transfer';

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

    public function scopeCompleted($query)
    {
        return $query->where('status', self::STATUS_COMPLETED);
    }

    public function scopeFailed($query)
    {
        return $query->where('status', self::STATUS_FAILED);
    }

    public function scopePending($query)
    {
        return $query->where('status', self::STATUS_PENDING);
    }

    public function isCompleted()
    {
        return $this->status === self::STATUS_COMPLETED;
    }

    public function isFailed()
    {
        return $this->status === self::STATUS_FAILED;
    }

    public function isPending()
    {
        return $this->status === self::STATUS_PENDING;
    }

    public function canBeRefunded()
    {
        return $this->status === self::STATUS_COMPLETED && 
               (!$this->refunded_at || $this->refund_amount < $this->amount);
    }

    public function getRemainingRefundableAmountAttribute()
    {
        if (!$this->canBeRefunded()) {
            return 0;
        }

        return $this->amount - ($this->refund_amount ?? 0);
    }

    public function getStatusColorAttribute()
    {
        $colors = [
            self::STATUS_PENDING => 'warning',
            self::STATUS_PROCESSING => 'info',
            self::STATUS_COMPLETED => 'success',
            self::STATUS_FAILED => 'danger',
            self::STATUS_CANCELLED => 'secondary',
            self::STATUS_REFUNDED => 'info',
            self::STATUS_PARTIALLY_REFUNDED => 'warning',
        ];

        return $colors[$this->status] ?? 'secondary';
    }
}
