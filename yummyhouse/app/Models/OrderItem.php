<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class OrderItem extends Model
{
    use HasFactory;

    protected $fillable = [
        'order_id',
        'food_id',
        'quantity',
        'unit_price',
        'total_price',
        'special_instructions'
    ];

    protected $casts = [
        'quantity' => 'integer',
        'unit_price' => 'decimal:2',
        'total_price' => 'decimal:2',
    ];

    public function order()
    {
        return $this->belongsTo(Order::class);
    }

     public function food()
    {
        return $this->belongsTo(Food::class);
    }


    public function getItemAttribute()
    {
        return $this->food;
    }

    // Get the item name
    public function getItemNameAttribute()
    {
        $item = $this->getItemAttribute();
        return $item ? $item->name : 'Unknown Item';
    }

    // Calculate total price based on quantity and unit price
    public function calculateTotal()
    {
        return round($this->quantity * $this->unit_price, 2);
    }

    // Update total price
    public function updateTotal()
    {
        $this->update(['total_price' => $this->calculateTotal()]);
        return $this;
    }
}
