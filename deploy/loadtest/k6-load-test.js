import http from 'k6/http';
import { check, sleep } from 'k6';

// Ramp traffic to validate HPA -> Cluster Autoscaler scaling.
export const options = {
  stages: [
    { duration: '2m', target: 50 },   // ramp up
    { duration: '5m', target: 200 },  // sustained load -> triggers HPA
    { duration: '2m', target: 0 },    // ramp down -> scale back in
  ],
  thresholds: { http_req_duration: ['p(95)<800'], http_req_failed: ['rate<0.01'] },
};

const BASE = __ENV.BASE_URL || 'https://streamingapp.blog4bharat.com';
export default function () {
  check(http.get(`${BASE}/`), { 'frontend 200': (r) => r.status === 200 });
  check(http.get(`${BASE}/api/auth/health`), { 'auth healthy': (r) => r.status === 200 });
  sleep(1);
}
