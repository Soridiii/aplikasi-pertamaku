
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue()],
  base: `/salinggih/`,
  server: {
    host: true,
    port: 5173
  }
})
