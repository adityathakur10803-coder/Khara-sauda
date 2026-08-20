// Khara Sauda Supabase client
// Set these values in the deployment environment before enabling production auth.
// Never put a service-role key in this file.
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2';

const SUPABASE_URL = window.KHARA_SAUDA_SUPABASE_URL || '';
const SUPABASE_PUBLISHABLE_KEY = window.KHARA_SAUDA_SUPABASE_PUBLISHABLE_KEY || '';

export const supabase = (SUPABASE_URL && SUPABASE_PUBLISHABLE_KEY)
  ? createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY)
  : null;

export async function signUp(email, password) {
  if (!supabase) throw new Error('Supabase is not configured yet.');
  return supabase.auth.signUp({ email, password });
}

export async function signIn(email, password) {
  if (!supabase) throw new Error('Supabase is not configured yet.');
  return supabase.auth.signInWithPassword({ email, password });
}

export async function signOut() {
  if (!supabase) return;
  return supabase.auth.signOut();
}
