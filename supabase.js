// Khara Sauda Supabase client foundation.
// Set these values in a deployment environment; never commit a service-role key.
const KHARA_SUPABASE_URL = window.KHARA_SUPABASE_URL || '';
const KHARA_SUPABASE_PUBLISHABLE_KEY = window.KHARA_SUPABASE_PUBLISHABLE_KEY || '';

let kharaSupabase = null;

async function loadSupabase() {
  if (kharaSupabase) return kharaSupabase;
  if (!KHARA_SUPABASE_URL || !KHARA_SUPABASE_PUBLISHABLE_KEY) return null;
  if (!window.supabase) {
    await new Promise((resolve, reject) => {
      const script = document.createElement('script');
      script.src = 'https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2';
      script.onload = resolve;
      script.onerror = reject;
      document.head.appendChild(script);
    });
  }
  kharaSupabase = window.supabase.createClient(KHARA_SUPABASE_URL, KHARA_SUPABASE_PUBLISHABLE_KEY);
  return kharaSupabase;
}

async function signUpBusiness({email, password, name, category, location, description}) {
  const client = await loadSupabase();
  if (!client) throw new Error('Supabase is not configured for this deployment.');
  const {data, error} = await client.auth.signUp({email, password, options:{data:{business_name:name, category, location}}});
  if (error) throw error;
  if (data.user) {
    const {error: profileError} = await client.from('businesses').insert({owner_id:data.user.id,name,category,location,description});
    if (profileError) throw profileError;
  }
  return data;
}

async function signInBusiness(email, password) {
  const client = await loadSupabase();
  if (!client) throw new Error('Supabase is not configured for this deployment.');
  const {data,error} = await client.auth.signInWithPassword({email,password});
  if (error) throw error;
  return data;
}

async function signOutBusiness() {
  const client = await loadSupabase();
  if (!client) return;
  const {error} = await client.auth.signOut();
  if (error) throw error;
}

async function getCurrentBusiness() {
  const client = await loadSupabase();
  if (!client) return null;
  const {data:{user}} = await client.auth.getUser();
  if (!user) return null;
  const {data,error} = await client.from('businesses').select('*').eq('owner_id',user.id).maybeSingle();
  if (error) throw error;
  return {user,business:data};
}

async function sendConnection(recipientId) {
  const client = await loadSupabase();
  const {data:{user}} = await client.auth.getUser();
  if (!user) throw new Error('Please sign in first.');
  const {data,error} = await client.from('connections').insert({requester_id:user.id,recipient_id:recipientId}).select().single();
  if (error) throw error;
  return data;
}

async function sendMessage(connectionId, body) {
  const client = await loadSupabase();
  const {data:{user}} = await client.auth.getUser();
  if (!user) throw new Error('Please sign in first.');
  const {data,error} = await client.from('messages').insert({connection_id:connectionId,sender_id:user.id,body}).select().single();
  if (error) throw error;
  return data;
}
