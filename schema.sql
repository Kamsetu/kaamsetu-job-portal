-- KaamSetu starter database schema for Supabase (PostgreSQL)
-- Run only in a new Supabase project after reviewing these policies.
create type public.user_role as enum ('candidate', 'employer', 'admin');
create type public.job_status as enum ('pending', 'published', 'rejected', 'closed');

create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  full_name text not null default '',
  phone text,
  role public.user_role not null default 'candidate',
  skills text,
  resume_path text,
  company_name text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.jobs (
  id bigint generated always as identity primary key,
  employer_id uuid not null references public.profiles(id) on delete cascade,
  title text not null,
  company_name text not null,
  location text not null,
  country text not null default 'India',
  category text not null default 'Other',
  employment_type text not null default 'Full-time',
  salary_text text,
  description text not null,
  status public.job_status not null default 'pending',
  is_premium boolean not null default false,
  created_at timestamptz not null default now(),
  expires_at timestamptz
);

create table public.applications (
  id bigint generated always as identity primary key,
  job_id bigint not null references public.jobs(id) on delete cascade,
  candidate_id uuid not null references public.profiles(id) on delete cascade,
  cover_note text,
  resume_path text,
  status text not null default 'submitted' check (status in ('submitted','reviewing','shortlisted','rejected','hired')),
  created_at timestamptz not null default now(),
  unique(job_id, candidate_id)
);

alter table public.profiles enable row level security;
alter table public.jobs enable row level security;
alter table public.applications enable row level security;

-- Profiles: users can read public profile fields and edit their own profile.
create policy "Profiles visible to signed-in users" on public.profiles
for select to authenticated using (true);
create policy "Users create own profile" on public.profiles
for insert to authenticated with check (auth.uid() = id);
create policy "Users update own profile" on public.profiles
for update to authenticated using (auth.uid() = id) with check (auth.uid() = id);

-- Published jobs are visible publicly; employers manage only their own listings.
create policy "Published jobs are public" on public.jobs
for select using (status = 'published' or (auth.uid() = employer_id));
create policy "Employers create own jobs" on public.jobs
for insert to authenticated with check (auth.uid() = employer_id and status = 'pending');
create policy "Employers update own jobs" on public.jobs
for update to authenticated using (auth.uid() = employer_id) with check (auth.uid() = employer_id);
create policy "Employers delete own jobs" on public.jobs
for delete to authenticated using (auth.uid() = employer_id);

-- Candidates can create and view their applications; employers can view applications to their jobs.
create policy "Candidate creates own application" on public.applications
for insert to authenticated with check (auth.uid() = candidate_id);
create policy "Candidate or job owner views applications" on public.applications
for select to authenticated using (
  auth.uid() = candidate_id or exists (
    select 1 from public.jobs j where j.id = job_id and j.employer_id = auth.uid()
  )
);
create policy "Candidate withdraws own application" on public.applications
for delete to authenticated using (auth.uid() = candidate_id);

-- IMPORTANT: Do not make a user an admin by changing a client-side value.
-- Set role='admin' for a trusted account manually in Supabase SQL editor.
-- For admin actions, add server-side/edge-function checks and strict policies.
