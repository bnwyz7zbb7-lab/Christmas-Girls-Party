-- Esquema aplicado al proyecto Christmas Girls Night (Supabase).
-- La sala se identifica mediante un UUID aleatorio compartido en el enlace.
-- La tabla no permite acceso directo: todas las operaciones pasan por RPC.
create table if not exists public.cgn_rooms (
  token uuid primary key,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);
alter table public.cgn_rooms enable row level security;
revoke all on table public.cgn_rooms from anon, authenticated, public;

-- Las funciones internas quedan en un esquema no expuesto por la API REST.
create schema if not exists cgn_private;
grant usage on schema cgn_private to anon, authenticated;

create or replace function cgn_private.create_room(p_token uuid, p_data jsonb)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if p_token is null or p_data is null or jsonb_typeof(p_data) <> 'object' then
    raise exception 'Invalid room data';
  end if;
  insert into public.cgn_rooms(token, data) values (p_token, p_data)
  on conflict (token) do nothing;
end;
$$;

create or replace function cgn_private.get_room(p_token uuid)
returns jsonb language sql security definer set search_path = '' as $$
  select data from public.cgn_rooms where token = p_token;
$$;

create or replace function cgn_private.save_room(p_token uuid, p_data jsonb)
returns void language plpgsql security definer set search_path = '' as $$
begin
  if p_token is null or p_data is null or jsonb_typeof(p_data) <> 'object' then
    raise exception 'Invalid room data';
  end if;
  update public.cgn_rooms set data = p_data, updated_at = now() where token = p_token;
  if not found then raise exception 'Room not found'; end if;
end;
$$;

revoke all on function cgn_private.create_room(uuid, jsonb) from public;
revoke all on function cgn_private.get_room(uuid) from public;
revoke all on function cgn_private.save_room(uuid, jsonb) from public;
grant execute on function cgn_private.create_room(uuid, jsonb) to anon, authenticated;
grant execute on function cgn_private.get_room(uuid) to anon, authenticated;
grant execute on function cgn_private.save_room(uuid, jsonb) to anon, authenticated;

-- Wrappers expuestos a la API: SECURITY INVOKER, delegan a funciones internas.
create or replace function public.cgn_create_room(p_token uuid, p_data jsonb)
returns void language sql security invoker set search_path = '' as $$
  select cgn_private.create_room(p_token, p_data);
$$;
create or replace function public.cgn_get_room(p_token uuid)
returns jsonb language sql security invoker set search_path = '' as $$
  select cgn_private.get_room(p_token);
$$;
create or replace function public.cgn_save_room(p_token uuid, p_data jsonb)
returns void language sql security invoker set search_path = '' as $$
  select cgn_private.save_room(p_token, p_data);
$$;

revoke all on function public.cgn_create_room(uuid, jsonb) from public;
revoke all on function public.cgn_get_room(uuid) from public;
revoke all on function public.cgn_save_room(uuid, jsonb) from public;
grant execute on function public.cgn_create_room(uuid, jsonb) to anon, authenticated;
grant execute on function public.cgn_get_room(uuid) to anon, authenticated;
grant execute on function public.cgn_save_room(uuid, jsonb) to anon, authenticated;
