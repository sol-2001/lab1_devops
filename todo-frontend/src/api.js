const API_URL = 'http://51.250.1.150:8081';

export async function getTasks() {
  const resp = await fetch(`${API_URL}/tasks`);
  return resp.json();
}

export async function createTask(title) {
  const resp = await fetch(`${API_URL}/tasks`, {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title }),
  });
  return resp.json();
}

export async function updateTask(id, title, completed) {
  const resp = await fetch(`${API_URL}/tasks/${id}`, {
    method: 'PUT',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ title, completed }),
  });
  return resp.json();
}

export async function deleteTask(id) {
  await fetch(`${API_URL}/tasks/${id}`, { method: 'DELETE' });
}

