# Use an official Node.js image as the base
FROM node:18-alpine

# Set working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json first (to leverage Docker caching)
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application files
COPY . .

# Build the React app
RUN yarn build

# Use Nginx to serve the built app
FROM nginx:alpine
COPY --from=0 /app/build /usr/share/nginx/html

# Expose port 80 for the application
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
