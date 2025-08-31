-- SQL command to create the tasks table for the Kollaborate app
-- This table stores user tasks with priority levels, due dates, and completion status

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_uid UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    description TEXT,
    due_date TIMESTAMP WITH TIME ZONE,
    priority TEXT NOT NULL DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
    is_completed BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create indexes for better query performance
CREATE INDEX idx_tasks_owner_uid ON tasks(owner_uid);
CREATE INDEX idx_tasks_priority ON tasks(priority);
CREATE INDEX idx_tasks_is_completed ON tasks(is_completed);
CREATE INDEX idx_tasks_due_date ON tasks(due_date);
CREATE INDEX idx_tasks_created_at ON tasks(created_at);

-- Create a trigger to automatically update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_tasks_updated_at 
    BEFORE UPDATE ON tasks 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;

-- Create policy to allow users to only see their own tasks
CREATE POLICY "Users can view their own tasks" ON tasks
    FOR SELECT USING (auth.uid()::text = owner_uid::text);

-- Create policy to allow users to insert their own tasks
CREATE POLICY "Users can insert their own tasks" ON tasks
    FOR INSERT WITH CHECK (auth.uid()::text = owner_uid::text);

-- Create policy to allow users to update their own tasks
CREATE POLICY "Users can update their own tasks" ON tasks
    FOR UPDATE USING (auth.uid()::text = owner_uid::text);

-- Create policy to allow users to delete their own tasks
CREATE POLICY "Users can delete their own tasks" ON tasks
    FOR DELETE USING (auth.uid()::text = owner_uid::text);
