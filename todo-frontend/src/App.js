import React, { useEffect, useState } from 'react';
import { getTasks, createTask, updateTask, deleteTask } from './api';

function App() {
  const [tasks, setTasks] = useState([]);
  const [newTitle, setNewTitle] = useState('');

  useEffect(() => {
    loadTasks();
  }, []);

  async function loadTasks() {
    const ts = await getTasks();
    setTasks(ts);
  }

  async function addTask() {
    if (!newTitle.trim()) return;
    await createTask(newTitle);
    setNewTitle('');
    loadTasks();
  }

  async function toggleTaskCompletion(task) {
    await updateTask(task.id, task.title, !task.completed);
    loadTasks();
  }

  async function removeTask(id) {
    await deleteTask(id);
    loadTasks();
  }

  return (
    <div style={{ margin: "20px" }}>
      <h1>Todo List</h1>
      <div>
        <input value={newTitle} onChange={e => setNewTitle(e.target.value)} placeholder="Новая таска"/>
        <button onClick={addTask}>Add</button>
      </div>
      <ul>
        {tasks.map(t => (
          <li key={t.id}>
            <span style={{textDecoration: t.completed ? 'line-through' : 'none'}}>
              {t.title}
            </span>
            <button onClick={() => toggleTaskCompletion(t)}>Toggle</button>
            <button onClick={() => removeTask(t.id)}>Delete</button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;
