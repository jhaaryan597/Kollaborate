-- SQL commands for missing database tables and functionality
-- This file contains the SQL commands for comments, reposts, and other social features

-- 1. Comments Table (if not already exists)
CREATE TABLE IF NOT EXISTS post_comments (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    post_id TEXT NOT NULL REFERENCES kollaborates(id) ON DELETE CASCADE,
    user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    comment_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- 2. Reposts Table
CREATE TABLE IF NOT EXISTS post_reposts (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    original_post_id TEXT NOT NULL REFERENCES kollaborates(id) ON DELETE CASCADE,
    reposted_by_user_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    repost_text TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- 3. User Follows Table
CREATE TABLE IF NOT EXISTS user_follows (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    follower_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    following_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW(),
    UNIQUE(follower_id, following_id)
);

-- 4. Direct Messages Table
CREATE TABLE IF NOT EXISTS direct_messages (
    id TEXT PRIMARY KEY DEFAULT gen_random_uuid()::text,
    sender_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    receiver_id TEXT NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message_text TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_post_comments_post_id ON post_comments(post_id);
CREATE INDEX IF NOT EXISTS idx_post_comments_user_id ON post_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_post_comments_created_at ON post_comments(created_at);

CREATE INDEX IF NOT EXISTS idx_post_reposts_original_post_id ON post_reposts(original_post_id);
CREATE INDEX IF NOT EXISTS idx_post_reposts_reposted_by_user_id ON post_reposts(reposted_by_user_id);
CREATE INDEX IF NOT EXISTS idx_post_reposts_created_at ON post_reposts(created_at);

CREATE INDEX IF NOT EXISTS idx_user_follows_follower_id ON user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following_id ON user_follows(following_id);

CREATE INDEX IF NOT EXISTS idx_direct_messages_sender_id ON direct_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_direct_messages_receiver_id ON direct_messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_direct_messages_created_at ON direct_messages(created_at);

-- Create triggers to automatically update timestamps
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_post_comments_updated_at 
    BEFORE UPDATE ON post_comments 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security (RLS)
ALTER TABLE post_comments ENABLE ROW LEVEL SECURITY;
ALTER TABLE post_reposts ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE direct_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for post_comments
CREATE POLICY "Users can view comments on any post" ON post_comments
    FOR SELECT USING (true);

CREATE POLICY "Users can insert their own comments" ON post_comments
    FOR INSERT WITH CHECK (auth.uid()::text = user_id::text);

CREATE POLICY "Users can update their own comments" ON post_comments
    FOR UPDATE USING (auth.uid()::text = user_id::text);

CREATE POLICY "Users can delete their own comments" ON post_comments
    FOR DELETE USING (auth.uid()::text = user_id::text);

-- RLS Policies for post_reposts
CREATE POLICY "Users can view all reposts" ON post_reposts
    FOR SELECT USING (true);

CREATE POLICY "Users can create their own reposts" ON post_reposts
    FOR INSERT WITH CHECK (auth.uid()::text = reposted_by_user_id::text);

CREATE POLICY "Users can delete their own reposts" ON post_reposts
    FOR DELETE USING (auth.uid()::text = reposted_by_user_id::text);

-- RLS Policies for user_follows
CREATE POLICY "Users can view all follows" ON user_follows
    FOR SELECT USING (true);

CREATE POLICY "Users can create their own follows" ON user_follows
    FOR INSERT WITH CHECK (auth.uid()::text = follower_id::text);

CREATE POLICY "Users can delete their own follows" ON user_follows
    FOR DELETE USING (auth.uid()::text = follower_id::text);

-- RLS Policies for direct_messages
CREATE POLICY "Users can view messages they sent or received" ON direct_messages
    FOR SELECT USING (auth.uid()::text = sender_id::text OR auth.uid()::text = receiver_id::text);

CREATE POLICY "Users can send messages" ON direct_messages
    FOR INSERT WITH CHECK (auth.uid()::text = sender_id::text);

CREATE POLICY "Users can update messages they sent" ON direct_messages
    FOR UPDATE USING (auth.uid()::text = sender_id::text);

CREATE POLICY "Users can delete messages they sent" ON direct_messages
    FOR DELETE USING (auth.uid()::text = sender_id::text);

-- Functions for incrementing counts
CREATE OR REPLACE FUNCTION increment_comments(post_id_param TEXT, increment_amount INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE kollaborates 
    SET comments_count = COALESCE(comments_count, 0) + increment_amount
    WHERE id = post_id_param;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION increment_reposts(post_id_param TEXT, increment_amount INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE kollaborates 
    SET reposts_count = COALESCE(reposts_count, 0) + increment_amount
    WHERE id = post_id_param;
END;
$$ LANGUAGE plpgsql;
