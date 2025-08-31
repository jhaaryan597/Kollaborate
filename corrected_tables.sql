-- Corrected SQL commands that match the existing database schema
-- Based on the user's actual Supabase tables

-- 1. Reposts Table (matching existing schema patterns)
CREATE TABLE IF NOT EXISTS public.post_reposts (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    original_post_id TEXT NOT NULL,
    reposted_by_user_id UUID NOT NULL,
    repost_text TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT post_reposts_pkey PRIMARY KEY (id),
    CONSTRAINT post_reposts_original_post_id_fkey FOREIGN KEY (original_post_id) REFERENCES public.kollaborates(id) ON DELETE CASCADE,
    CONSTRAINT post_reposts_reposted_by_user_id_fkey FOREIGN KEY (reposted_by_user_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- 2. User Follows Table
CREATE TABLE IF NOT EXISTS public.user_follows (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    follower_id UUID NOT NULL,
    following_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_follows_pkey PRIMARY KEY (id),
    CONSTRAINT user_follows_follower_id_fkey FOREIGN KEY (follower_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT user_follows_following_id_fkey FOREIGN KEY (following_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    UNIQUE(follower_id, following_id)
);

-- 3. Direct Messages Table
CREATE TABLE IF NOT EXISTS public.direct_messages (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    sender_id UUID NOT NULL,
    receiver_id UUID NOT NULL,
    message_text TEXT NOT NULL,
    is_read BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT direct_messages_pkey PRIMARY KEY (id),
    CONSTRAINT direct_messages_sender_id_fkey FOREIGN KEY (sender_id) REFERENCES auth.users(id) ON DELETE CASCADE,
    CONSTRAINT direct_messages_receiver_id_fkey FOREIGN KEY (receiver_id) REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_post_reposts_original_post_id ON public.post_reposts(original_post_id);
CREATE INDEX IF NOT EXISTS idx_post_reposts_reposted_by_user_id ON public.post_reposts(reposted_by_user_id);
CREATE INDEX IF NOT EXISTS idx_post_reposts_created_at ON public.post_reposts(created_at);

CREATE INDEX IF NOT EXISTS idx_user_follows_follower_id ON public.user_follows(follower_id);
CREATE INDEX IF NOT EXISTS idx_user_follows_following_id ON public.user_follows(following_id);

CREATE INDEX IF NOT EXISTS idx_direct_messages_sender_id ON public.direct_messages(sender_id);
CREATE INDEX IF NOT EXISTS idx_direct_messages_receiver_id ON public.direct_messages(receiver_id);
CREATE INDEX IF NOT EXISTS idx_direct_messages_created_at ON public.direct_messages(created_at);

-- Enable Row Level Security (RLS)
ALTER TABLE public.post_reposts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_follows ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.direct_messages ENABLE ROW LEVEL SECURITY;

-- RLS Policies for post_reposts (matching existing pattern)
CREATE POLICY "Public reposts are viewable by everyone." ON public.post_reposts FOR SELECT USING (true);
CREATE POLICY "Users can insert their own reposts." ON public.post_reposts FOR INSERT WITH CHECK (auth.uid() = reposted_by_user_id);
CREATE POLICY "Users can delete their own reposts." ON public.post_reposts FOR DELETE USING (auth.uid() = reposted_by_user_id);

-- RLS Policies for user_follows
CREATE POLICY "Public follows are viewable by everyone." ON public.user_follows FOR SELECT USING (true);
CREATE POLICY "Users can insert their own follows." ON public.user_follows FOR INSERT WITH CHECK (auth.uid() = follower_id);
CREATE POLICY "Users can delete their own follows." ON public.user_follows FOR DELETE USING (auth.uid() = follower_id);

-- RLS Policies for direct_messages
CREATE POLICY "Users can view messages they sent or received." ON public.direct_messages FOR SELECT USING (auth.uid() = sender_id OR auth.uid() = receiver_id);
CREATE POLICY "Users can send messages." ON public.direct_messages FOR INSERT WITH CHECK (auth.uid() = sender_id);
CREATE POLICY "Users can update messages they sent." ON public.direct_messages FOR UPDATE USING (auth.uid() = sender_id);
CREATE POLICY "Users can delete messages they sent." ON public.direct_messages FOR DELETE USING (auth.uid() = sender_id);

-- Add reposts_count column to kollaborates table (if not exists)
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'kollaborates' AND column_name = 'reposts_count') THEN
        ALTER TABLE public.kollaborates ADD COLUMN reposts_count INT NOT NULL DEFAULT 0;
    END IF;
END $$;

-- Function for incrementing reposts count (matching existing pattern)
CREATE OR REPLACE FUNCTION increment_reposts(post_id TEXT, increment_amount INT)
RETURNS VOID AS $$
BEGIN
    UPDATE public.kollaborates
    SET reposts_count = reposts_count + increment_amount
    WHERE id = post_id;
END;
$$ LANGUAGE plpgsql;
