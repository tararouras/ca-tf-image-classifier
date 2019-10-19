import random

# file containing pairs of (duration, rate_per_30)
INPUT_INTERVALS_FILE = 'input_intervals.txt'
INPUT_INTERVALS = []

OUTPUT = 'intervals/intervals.txt'

def main():
    with open(INPUT_INTERVALS_FILE, 'r') as fh:
        for line in fh:
            INPUT_INTERVALS.append([float(n) for n in line.split()[:2]])
    with open(OUTPUT, 'w') as fh:
        for input_pair in INPUT_INTERVALS:
            duration = input_pair[0]
            rate_per_30 = input_pair[1]
            current_time = 0.0
            while current_time < duration:
                interval = random.expovariate(rate_per_30 / 30.0)
                fh.write('{}\n'.format(interval))
                current_time += interval


if __name__ == "__main__":
    main()

