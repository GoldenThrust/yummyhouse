<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class VehicleInfo extends Model
{
    use HasFactory;

    protected $fillable = [
        'user_id',
        'vehicle_type',
        'vehicle_make',
        'vehicle_model',
        'vehicle_year',
        'vehicle_color',
        'license_plate',
        'insurance_number',
        'insurance_expiry',
        'registration_number',
        'registration_expiry',
        'driving_license_number',
        'driving_license_expiry',
        'vehicle_documents',
        'is_verified',
        'verified_at',
        'verified_by',
        'notes'
    ];

    protected $casts = [
        'vehicle_year' => 'integer',
        'insurance_expiry' => 'date',
        'registration_expiry' => 'date',
        'driving_license_expiry' => 'date',
        'vehicle_documents' => 'array',
        'is_verified' => 'boolean',
        'verified_at' => 'datetime',
    ];

    const VEHICLE_TYPES = [
        'motorcycle' => 'Motorcycle',
        'scooter' => 'Scooter',
        'bicycle' => 'Bicycle',
        'car' => 'Car',
        'van' => 'Van',
        'truck' => 'Truck',
        'walking' => 'Walking/On Foot'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }

    public function verifiedBy()
    {
        return $this->belongsTo(User::class, 'verified_by');
    }

    public function deliveryTrackings()
    {
        return $this->hasMany(DeliveryTracking::class, 'delivery_person_id', 'user_id');
    }

    public function scopeVerified($query)
    {
        return $query->where('is_verified', true);
    }

    public function scopeUnverified($query)
    {
        return $query->where('is_verified', false);
    }

    public function scopeByVehicleType($query, $type)
    {
        return $query->where('vehicle_type', $type);
    }

    public function scopeDocumentsExpiringSoon($query, $days = 30)
    {
        $cutoffDate = now()->addDays($days);
        
        return $query->where(function($q) use ($cutoffDate) {
            $q->where('insurance_expiry', '<=', $cutoffDate)
              ->orWhere('registration_expiry', '<=', $cutoffDate)
              ->orWhere('driving_license_expiry', '<=', $cutoffDate);
        });
    }

    public function isDocumentationValid()
    {
        $today = now()->toDateString();
        
        return $this->insurance_expiry >= $today &&
               $this->registration_expiry >= $today &&
               $this->driving_license_expiry >= $today;
    }

    public function hasExpiredDocuments()
    {
        return !$this->isDocumentationValid();
    }

    public function getExpiringDocumentsAttribute()
    {
        $expiring = [];
        $cutoffDate = now()->addDays(30);
        
        if ($this->insurance_expiry <= $cutoffDate) {
            $expiring[] = 'insurance';
        }
        
        if ($this->registration_expiry <= $cutoffDate) {
            $expiring[] = 'registration';
        }
        
        if ($this->driving_license_expiry <= $cutoffDate) {
            $expiring[] = 'driving_license';
        }
        
        return $expiring;
    }

    public function getVehicleTypeNameAttribute()
    {
        return self::VEHICLE_TYPES[$this->vehicle_type] ?? $this->vehicle_type;
    }

    public function getFullVehicleNameAttribute()
    {
        $parts = array_filter([
            $this->vehicle_year,
            $this->vehicle_make,
            $this->vehicle_model
        ]);
        
        return implode(' ', $parts) ?: 'Vehicle';
    }

    public function canDeliver()
    {
        return $this->is_verified && 
               $this->isDocumentationValid() && 
               $this->user && 
               $this->user->role === 'delivery_persons';
    }

    public function markAsVerified($verifiedBy = null)
    {
        $this->update([
            'is_verified' => true,
            'verified_at' => now(),
            'verified_by' => $verifiedBy
        ]);
        
        return $this;
    }

    public function markAsUnverified($notes = null)
    {
        $this->update([
            'is_verified' => false,
            'verified_at' => null,
            'verified_by' => null,
            'notes' => $notes
        ]);
        
        return $this;
    }
}
