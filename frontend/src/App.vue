<script setup>
import { ref } from 'vue';
import CommentSection from './components/CommentSection.vue';
import DOMPurify from 'dompurify';


const userId = ref('');
const users = ref(null);
const newEmail = ref('');
const apiUrl = `${import.meta.env.VITE_HOST}`;

const sanitizeHTML = (inputHtml) => {
    return DOMPurify.sanitize(inputHtml);
};

const getUser = async () => {
  try {
    const response = await fetch(`${apiUrl}/api/user/${userId.value}`);
    
    if (!response.ok) {
      throw new Error(`API Error: ${response.status} - ${response.statusText}`);
    }

    const data = await response.json();
    
    if (data.length === 0) {
      alert("No user found with the given ID");
      return;
    }

    users.value = data;

  } catch (error) {
    console.error("Error fetching user data:", error);
    alert("An error occurred while fetching the user data. Please try again later.");
  }
};



const changeEmail = async () => {
  const validEmail = /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(newEmail.value);
  if (!validEmail) {
    alert("Please enter a valid email address.");
    return;
  }

  await fetch(`${apiUrl}/api/user/${userId.value}/change-email`, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/x-www-form-urlencoded',
    },
    body: new URLSearchParams({
      email: sanitizeHTML(newEmail.value),
    }).toString(),
  });
};

</script>

<template>
  <div id="app">
    <h1>User Dashboard</h1>
    <div>
      <input v-model="userId" placeholder="Enter User ID" />
      <button @click="getUser">Get User Info</button>
    </div>
    <div v-if="users">
      <template v-for="user in users">
        <h2>{{ user.name }}</h2>
        <p>Email: {{ user.email }}</p>
        <hr />
      </template>
    </div>
    <CommentSection />
    <form @submit.prevent="changeEmail">
      <h3>Change Email</h3>
      <input v-model="newEmail" placeholder="New Email" />
      <button type="submit">Submit</button>
    </form>
  </div>
</template>