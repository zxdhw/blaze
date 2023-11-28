import math

def collision_probability(num_threads, num_bins):
    no_collision_prob = 1.0
    for i in range(num_threads):
        no_collision_prob *= (num_bins - i) / num_bins
    collision_prob = 1 - no_collision_prob
    return collision_prob

num_threads = 8
num_bins = 4096

probability = collision_probability(num_threads, num_bins)
print("冲突的概率为:", probability)
