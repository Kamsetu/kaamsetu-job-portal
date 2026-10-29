# Security notes
- Never commit Supabase service-role keys, Razorpay secret keys, passwords, or private API tokens.
- Client-side checks are not security. Enforce roles and payment verification on the server/Edge Functions.
- Keep resumes in private storage and issue short-lived signed URLs only to authorized employers.
- The included SQL is a starter, not a complete production security review. Test policies with candidate, employer, and admin accounts before launch.
- Sample job listings are examples only and must not be represented as verified vacancies.
