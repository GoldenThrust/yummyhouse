<?php

namespace Database\Factories;

use App\Models\RestaurantStaff;
use App\Models\User;
use App\Models\Restaurant;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends \Illuminate\Database\Eloquent\Factories\Factory<\App\Models\RestaurantStaff>
 */
class RestaurantStaffFactory extends Factory
{
    protected $model = RestaurantStaff::class;

    /**
     * Define the model's default state.
     *
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $roles = ['manager', 'chef', 'cashier', 'waiter', 'kitchen_helper', 'delivery_person'];
        $employmentTypes = ['full_time', 'part_time', 'contract'];
        $statuses = ['active', 'inactive'];
        
        $role = $this->faker->randomElement($roles);
        $hireDate = $this->faker->dateTimeBetween('-2 years', 'now');
        
        return [
            'user_id' => User::factory(),
            'restaurant_id' => Restaurant::factory(),
            'role' => $role,
            'salary' => $this->faker->randomFloat(2, 1500, 8000), // Monthly salary between $1,500 - $8,000
            'employment_type' => $this->faker->randomElement($employmentTypes),
            'hire_date' => $hireDate,
            'end_date' => null,
            'status' => $this->faker->randomElement($statuses),
            'notes' => $this->faker->optional(0.3)->sentence(),
            'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS[$role] ?? [],
        ];
    }

    /**
     * Indicate that the staff member is active.
     */
    public function active(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'active',
            'end_date' => null,
        ]);
    }

    /**
     * Indicate that the staff member is inactive.
     */
    public function inactive(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'inactive',
        ]);
    }

    /**
     * Indicate that the staff member is terminated.
     */
    public function terminated(): static
    {
        return $this->state(fn (array $attributes) => [
            'status' => 'terminated',
            'end_date' => $this->faker->dateTimeBetween($attributes['hire_date'], 'now'),
        ]);
    }

    /**
     * Indicate that the staff member is a manager.
     */
    public function manager(): static
    {
        return $this->state(fn (array $attributes) => [
            'role' => 'manager',
            'salary' => $this->faker->randomFloat(2, 4000, 8000),
            'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS['manager'],
        ]);
    }

    /**
     * Indicate that the staff member is a chef.
     */
    public function chef(): static
    {
        return $this->state(fn (array $attributes) => [
            'role' => 'chef',
            'salary' => $this->faker->randomFloat(2, 3000, 6000),
            'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS['chef'],
        ]);
    }

    /**
     * Indicate that the staff member is a waiter.
     */
    public function waiter(): static
    {
        return $this->state(fn (array $attributes) => [
            'role' => 'waiter',
            'salary' => $this->faker->randomFloat(2, 1500, 3000),
            'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS['waiter'],
        ]);
    }

    /**
     * Indicate that the staff member is a delivery person.
     */
    public function deliveryPerson(): static
    {
        return $this->state(fn (array $attributes) => [
            'role' => 'delivery_person',
            'salary' => $this->faker->randomFloat(2, 2000, 4000),
            'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS['delivery_person'],
        ]);
    }

    /**
     * Indicate that the staff member is full-time.
     */
    public function fullTime(): static
    {
        return $this->state(fn (array $attributes) => [
            'employment_type' => 'full_time',
        ]);
    }

    /**
     * Indicate that the staff member is part-time.
     */
    public function partTime(): static
    {
        return $this->state(fn (array $attributes) => [
            'employment_type' => 'part_time',
            'salary' => $this->faker->randomFloat(2, 800, 2500),
        ]);
    }

    /**
     * Create staff for a specific restaurant.
     */
    public function forRestaurant(Restaurant $restaurant): static
    {
        return $this->state(fn (array $attributes) => [
            'restaurant_id' => $restaurant->id,
        ]);
    }

    /**
     * Create staff for a specific user.
     */
    public function forUser(User $user): static
    {
        return $this->state(fn (array $attributes) => [
            'user_id' => $user->id,
        ]);
    }
}
