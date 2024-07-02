#include <iostream>
#include <vector>

using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);

    int n, p, x;
    cin >> n >> p >> x;

    long long acc = 0;
    vector<long long> arr(n);
    for (int i = 0; i < n; i++) {
        cin >> arr[i];
        acc += arr[i];
    }

    // Enumerating
    long long res = 0;
    for (int i = 0; i < n; i++) {
        long long left = (acc - arr[i]) % x;

        // r for the corresponding congruence
        long long r = (left == 0) ? 0 : (x - left);
        if (p >= r) {
            res += (p - r) / x;
            if (r > 0) res++; // Need to add 1

            // Need to exclude the equal case
            if (arr[i] <= p && arr[i] % x == r) res--;
        }
    }
    cout << res << "\n";

    return 0;
}
