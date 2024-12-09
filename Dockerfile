# Menggunakan base image Node.js versi 14
FROM node:14

# Menentukan working directory dalam container
WORKDIR /app

# Menyalin semua source code ke dalam working directory
COPY . .

# Menentukan environment variables
ENV NODE_ENV=production DB_HOST=item-db

# Menginstal dependencies hanya untuk production dan build aplikasi
RUN npm install --production --unsafe-perm && npm run build

# Mengekspos port 8080
EXPOSE 8080

# Menentukan perintah default untuk menjalankan server
CMD ["npm", "start"]
