# Use a Node.js image as the base
FROM node:18

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the container
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all project files into the container
COPY . .

# Expose the Angular development server port
EXPOSE 4200

# Start the Angular development server
CMD ["npm", "run", "start", "--", "--host", "0.0.0.0"]

