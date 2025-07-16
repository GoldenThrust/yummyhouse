<?php

namespace Database\Seeders;

use App\Models\RestaurantStaff;
use App\Models\Restaurant;
use App\Models\User;
use Illuminate\Database\Seeder;

class RestaurantStaffSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Get all restaurants
        $restaurants = Restaurant::all();

        if ($restaurants->isEmpty()) {
            $this->command->warn('No restaurants found. Please run RestaurantSeeder first.');
            return;
        }

        foreach ($restaurants as $restaurant) {
            // Create 1 manager per restaurant
            $manager = User::factory()->create([
                'role' => 'staff',
                'name' => fake()->name(),
                'email' => fake()->unique()->safeEmail(),
            ]);

            RestaurantStaff::factory()
                ->manager()
                ->active()
                ->fullTime()
                ->forRestaurant($restaurant)
                ->forUser($manager)
                ->create();

            // Create 1-2 chefs per restaurant
            $chefCount = fake()->numberBetween(1, 2);
            for ($i = 0; $i < $chefCount; $i++) {
                $chef = User::factory()->create([
                    'role' => 'staff',
                    'name' => fake()->name(),
                    'email' => fake()->unique()->safeEmail(),
                ]);

                RestaurantStaff::factory()
                    ->chef()
                    ->active()
                    ->fullTime()
                    ->forRestaurant($restaurant)
                    ->forUser($chef)
                    ->create();
            }

            // Create 2-4 waiters per restaurant
            $waiterCount = fake()->numberBetween(2, 4);
            for ($i = 0; $i < $waiterCount; $i++) {
                $waiter = User::factory()->create([
                    'role' => 'staff',
                    'name' => fake()->name(),
                    'email' => fake()->unique()->safeEmail(),
                ]);

                $employmentType = fake()->randomElement(['full_time', 'part_time']);
                
                RestaurantStaff::factory()
                    ->waiter()
                    ->active()
                    ->state(['employment_type' => $employmentType])
                    ->forRestaurant($restaurant)
                    ->forUser($waiter)
                    ->create();
            }

            // Create 1 cashier per restaurant
            $cashier = User::factory()->create([
                'role' => 'staff',
                'name' => fake()->name(),
                'email' => fake()->unique()->safeEmail(),
            ]);

            RestaurantStaff::factory()
                ->state([
                    'role' => 'cashier',
                    'salary' => fake()->randomFloat(2, 2000, 4000),
                    'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS['cashier'],
                ])
                ->active()
                ->fullTime()
                ->forRestaurant($restaurant)
                ->forUser($cashier)
                ->create();

            // Create 1-2 delivery persons per restaurant
            $deliveryCount = fake()->numberBetween(1, 2);
            for ($i = 0; $i < $deliveryCount; $i++) {
                $deliveryPerson = User::factory()->create([
                    'role' => 'staff',
                    'name' => fake()->name(),
                    'email' => fake()->unique()->safeEmail(),
                ]);

                // Create vehicle info for delivery person
                $deliveryPerson->vehicleInfo()->create([
                    'vehicle_type' => fake()->randomElement(['car', 'motorcycle', 'bicycle']),
                    'vehicle_brand' => fake()->randomElement(['Honda', 'Toyota', 'Yamaha', 'Suzuki']),
                    'vehicle_model' => fake()->word(),
                    'license_plate' => fake()->regexify('[A-Z]{2}[0-9]{4}'),
                    'license_number' => fake()->regexify('[A-Z0-9]{10}'),
                    'is_verified' => fake()->boolean(80), // 80% chance of being verified
                ]);

                RestaurantStaff::factory()
                    ->deliveryPerson()
                    ->active()
                    ->fullTime()
                    ->forRestaurant($restaurant)
                    ->forUser($deliveryPerson)
                    ->create();
            }

            // Create 1-2 kitchen helpers per restaurant
            $helperCount = fake()->numberBetween(1, 2);
            for ($i = 0; $i < $helperCount; $i++) {
                $helper = User::factory()->create([
                    'role' => 'staff',
                    'name' => fake()->name(),
                    'email' => fake()->unique()->safeEmail(),
                ]);

                RestaurantStaff::factory()
                    ->state([
                        'role' => 'kitchen_helper',
                        'salary' => fake()->randomFloat(2, 1200, 2500),
                        'permissions' => RestaurantStaff::DEFAULT_PERMISSIONS['kitchen_helper'],
                    ])
                    ->active()
                    ->partTime()
                    ->forRestaurant($restaurant)
                    ->forUser($helper)
                    ->create();
            }

            // Occasionally create some terminated staff (10% chance)
            if (fake()->boolean(10)) {
                $terminatedStaff = User::factory()->create([
                    'role' => 'staff',
                    'name' => fake()->name(),
                    'email' => fake()->unique()->safeEmail(),
                ]);

                RestaurantStaff::factory()
                    ->terminated()
                    ->forRestaurant($restaurant)
                    ->forUser($terminatedStaff)
                    ->create();
            }
        }

        $this->command->info('Restaurant staff seeded successfully!');
    }
}
