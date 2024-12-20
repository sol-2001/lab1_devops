export async function getTasks() {
    const resp = await fetch('http://84.252.131.15:8080/tasks');
    return resp.json();
  }
  
  export async function createTask(title) {
    const resp = await fetch('http://84.252.131.15:8080/tasks', {
      method: 'POST',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ title })
    });
    return resp.json();
  }
  
  export async function updateTask(id, title, completed) {
    const resp = await fetch(`http://84.252.131.15:8080/tasks/${id}`, {
      method: 'PUT',
      headers: {'Content-Type': 'application/json'},
      body: JSON.stringify({ title, completed })
    });
    return resp.json();
  }
  
  export async function deleteTask(id) {
    await fetch(`http://84.252.131.15:8080/tasks/${id}`, { method: 'DELETE' });
  }
  
