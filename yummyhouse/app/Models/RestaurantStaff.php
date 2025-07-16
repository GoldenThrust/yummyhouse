<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Carbon\Carbon;

class RestaurantStaff extends Model
{
    use HasFactory;

    protected $table = 'restaurant_staff';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'user_id',
        'restaurant_id',
        'role',
        'salary',
        'employment_type',
        'hire_date',
        'end_date',
        'status',
        'notes',
        'permissions',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'hire_date' => 'datetime',
        'end_date' => 'datetime',
        'salary' => 'decimal:2',
        'permissions' => 'array',
    ];

    /**
     * Staff roles available
     */
    public const ROLES = [
        'manager' => 'Manager',
        'chef' => 'Chef',
        'cashier' => 'Cashier',
        'waiter' => 'Waiter',
        'kitchen_helper' => 'Kitchen Helper',
        'delivery_person' => 'Delivery Person',
    ];

    /**
     * Employment types available
     */
    public const EMPLOYMENT_TYPES = [
        'full_time' => 'Full Time',
        'part_time' => 'Part Time',
        'contract' => 'Contract',
    ];

    /**
     * Staff status options
     */
    public const STATUSES = [
        'active' => 'Active',
        'inactive' => 'Inactive',
        'terminated' => 'Terminated',
    ];

    /**
     * Default permissions for each role
     */
    public const DEFAULT_PERMISSIONS = [
        'manager' => [
            'manage_staff',
            'manage_menu',
            'view_orders',
            'manage_orders',
            'view_reports',
            'manage_restaurant_settings'
        ],
        'chef' => [
            'view_orders',
            'update_order_status',
            'manage_menu'
        ],
        'cashier' => [
            'view_orders',
            'manage_orders',
            'process_payments'
        ],
        'waiter' => [
            'view_orders',
            'update_order_status'
        ],
        'kitchen_helper' => [
            'view_orders'
        ],
        'delivery_person' => [
            'view_orders',
            'update_delivery_status',
            'access_delivery_routes'
        ]
    ];

    // Relationships

    /**
     * Get the user that owns the staff record.
     */
    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    /**
     * Get the restaurant that owns the staff record.
     */
    public function restaurant(): BelongsTo
    {
        return $this->belongsTo(Restaurant::class);
    }

    // Scopes

    /**
     * Scope a query to only include active staff.
     */
    public function scopeActive($query)
    {
        return $query->where('status', 'active');
    }

    /**
     * Scope a query to only include inactive staff.
     */
    public function scopeInactive($query)
    {
        return $query->where('status', 'inactive');
    }

    /**
     * Scope a query to only include terminated staff.
     */
    public function scopeTerminated($query)
    {
        return $query->where('status', 'terminated');
    }

    /**
     * Scope a query by role.
     */
    public function scopeByRole($query, $role)
    {
        return $query->where('role', $role);
    }

    /**
     * Scope a query by restaurant.
     */
    public function scopeByRestaurant($query, $restaurantId)
    {
        return $query->where('restaurant_id', $restaurantId);
    }

    /**
     * Scope a query to delivery persons only.
     */
    public function scopeDeliveryPersons($query)
    {
        return $query->where('role', 'delivery_person');
    }

    /**
     * Scope a query to available delivery persons.
     */
    public function scopeAvailableDeliveryPersons($query)
    {
        return $query->deliveryPersons()
                    ->active()
                    ->whereHas('user.vehicleInfo', function($q) {
                        $q->where('is_verified', true);
                    })
                    ->whereDoesntHave('user.deliveryTrackings', function($q) {
                        $q->whereIn('status', ['assigned', 'picked_up', 'on_route']);
                    });
    }

    // Accessors & Mutators

    /**
     * Get the formatted role name.
     */
    public function getFormattedRoleAttribute()
    {
        return self::ROLES[$this->role] ?? ucfirst($this->role);
    }

    /**
     * Get the formatted employment type.
     */
    public function getFormattedEmploymentTypeAttribute()
    {
        return self::EMPLOYMENT_TYPES[$this->employment_type] ?? ucfirst(str_replace('_', ' ', $this->employment_type));
    }

    /**
     * Get the formatted status.
     */
    public function getFormattedStatusAttribute()
    {
        return self::STATUSES[$this->status] ?? ucfirst($this->status);
    }

    /**
     * Get the tenure in years.
     */
    public function getTenureAttribute()
    {
        $endDate = $this->end_date ?? Carbon::now();
        return Carbon::parse($this->hire_date)->diffInYears($endDate);
    }

    /**
     * Get the tenure in a human readable format.
     */
    public function getTenureForHumansAttribute()
    {
        $endDate = $this->end_date ?? Carbon::now();
        return Carbon::parse($this->hire_date)->diffForHumans($endDate, true);
    }

    // Helper Methods

    /**
     * Check if the staff member is active.
     */
    public function isActive(): bool
    {
        return $this->status === 'active';
    }

    /**
     * Check if the staff member is inactive.
     */
    public function isInactive(): bool
    {
        return $this->status === 'inactive';
    }

    /**
     * Check if the staff member is terminated.
     */
    public function isTerminated(): bool
    {
        return $this->status === 'terminated';
    }

    /**
     * Check if the staff member is a manager.
     */
    public function isManager(): bool
    {
        return $this->role === 'manager';
    }

    /**
     * Check if the staff member is a chef.
     */
    public function isChef(): bool
    {
        return $this->role === 'chef';
    }

    /**
     * Check if the staff member is a delivery person.
     */
    public function isDeliveryPerson(): bool
    {
        return $this->role === 'delivery_person';
    }

    /**
     * Check if the staff member has a specific permission.
     */
    public function hasPermission(string $permission): bool
    {
        $permissions = $this->permissions ?? self::DEFAULT_PERMISSIONS[$this->role] ?? [];
        return in_array($permission, $permissions);
    }

    /**
     * Check if staff can manage other staff.
     */
    public function canManageStaff(): bool
    {
        return $this->hasPermission('manage_staff');
    }

    /**
     * Check if staff can manage menu.
     */
    public function canManageMenu(): bool
    {
        return $this->hasPermission('manage_menu');
    }

    /**
     * Check if staff can view orders.
     */
    public function canViewOrders(): bool
    {
        return $this->hasPermission('view_orders');
    }

    /**
     * Check if staff can manage orders.
     */
    public function canManageOrders(): bool
    {
        return $this->hasPermission('manage_orders');
    }

    /**
     * Check if staff can update delivery status.
     */
    public function canUpdateDeliveryStatus(): bool
    {
        return $this->hasPermission('update_delivery_status');
    }

    /**
     * Check if staff can access delivery routes.
     */
    public function canAccessDeliveryRoutes(): bool
    {
        return $this->hasPermission('access_delivery_routes');
    }

    /**
     * Get the vehicle info for delivery person.
     */
    public function getVehicleInfo()
    {
        if ($this->isDeliveryPerson()) {
            return $this->user->vehicleInfo;
        }
        return null;
    }

    /**
     * Check if the delivery person can deliver orders.
     */
    public function canDeliverOrders(): bool
    {
        return $this->isDeliveryPerson() &&
            $this->isActive() &&
            $this->user->canDeliverOrders();
    }

    /**
     * Get delivery trackings for this delivery person.
     */
    public function deliveryTrackings()
    {
        if ($this->isDeliveryPerson()) {
            return $this->user->deliveryTrackings();
        }
        return collect();
    }

    /**
     * Get delivered orders for this delivery person.
     */
    public function deliveredOrders()
    {
        if ($this->isDeliveryPerson()) {
            return $this->user->deliveredOrders();
        }
        return collect();
    }

    /**
     * Get current active delivery for this delivery person.
     */
    public function getCurrentDelivery()
    {
        if ($this->isDeliveryPerson()) {
            return $this->user->deliveryTrackings()
                              ->whereIn('status', ['assigned', 'picked_up', 'on_route'])
                              ->first();
        }
        return null;
    }

    /**
     * Check if delivery person is currently available for delivery.
     */
    public function isAvailableForDelivery(): bool
    {
        return $this->isDeliveryPerson() &&
               $this->isActive() &&
               $this->canDeliverOrders() &&
               $this->getCurrentDelivery() === null;
    }
}
