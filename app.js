const $=s=>document.querySelector(s),grid=$('#businessGrid'),search=$('#search'),category=$('#category');
let client;
async function render(){
  if(!client){grid.innerHTML='<div class="empty">Loading businesses…</div>';return}
  const q=search.value.trim(),c=category.value;
  let query=client.from('businesses').select('id,name,category,location,description').order('created_at',{ascending:false}).limit(24);
  if(c) query=query.eq('category',c);
  if(q) query=query.or(`name.ilike.%${q}%,category.ilike.%${q}%,location.ilike.%${q}%,description.ilike.%${q}%`);
  const {data,error}=await query;
  if(error){grid.innerHTML=`<div class="empty">Unable to load businesses. ${error.message}</div>`;return}
  grid.innerHTML=(data||[]).map(b=>`<article class="biz"><div class="bizicon">🏢</div><div><h3>${escapeHtml(b.name)}</h3><p>${escapeHtml(b.category||'Business')} · ${escapeHtml(b.location||'Location not listed')}</p><span>${escapeHtml(b.description||'Open to business connections')}</span></div><button class="connect" onclick="openBusiness('${b.id}')">View</button></article>`).join('')||'<div class="empty">No matching businesses found.</div>';
}
function escapeHtml(v){return String(v||'').replace(/[&<>'"]/g,m=>({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[m]))}
function openBusiness(id){location.href=`business.html?id=${encodeURIComponent(id)}`}
function openModal(title,body){$('#modalTitle').textContent=title;$('#modalBody').innerHTML=body;$('#modal').classList.add('show')}
function connect(){openModal('Sign in to connect',`<p>Create a real business account to connect, message businesses and send structured enquiries.</p><a class="btn primary" href="auth.html">Sign in / Create account</a>`)}
function openSignup(){location.href='auth.html'}
function closeModal(){$('#modal').classList.remove('show')}
async function init(){
  if(window.supabase){client=window.supabase.createClient(window.KHARA_SUPABASE_URL,window.KHARA_SUPABASE_PUBLISHABLE_KEY);await render()}
  else grid.innerHTML='<div class="empty">Supabase client unavailable.</div>';
}
search.addEventListener('input',render);category.addEventListener('change',render);init();