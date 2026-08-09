import instaloader
import json
import os
import requests
from datetime import datetime

# Define the clubs to scrape
CLUB_USERNAMES = [
    "gdgc.dypcoe",     # GDGC DYPCOE
    "itesa.dyp",       # ITESA DYPCOE
    "acesdypcoe"       # ACES DYPCOE (Try 'aces_dypcoe' if this 404s)
]

# Output directories
DATA_DIR = "assets/data"
AVATARS_DIR = "assets/club_avatars"
POSTS_DIR = "assets/club_posts"

os.makedirs(DATA_DIR, exist_ok=True)
os.makedirs(AVATARS_DIR, exist_ok=True)
os.makedirs(POSTS_DIR, exist_ok=True)

def download_image(url, filepath):
    try:
        response = requests.get(url, stream=True)
        if response.status_code == 200:
            with open(filepath, 'wb') as f:
                for chunk in response.iter_content(1024):
                    f.write(chunk)
            return filepath
    except Exception as e:
        print(f"Failed to download {url}: {e}")
    return None

def main():
    print("Initializing Instaloader...")
    L = instaloader.Instaloader()
    
    print("TIP: For best results, log in with a dummy Instagram account.")
    username = input("Instagram Username (press Enter to skip): ")
    if username:
        password = input("Instagram Password: ")
        try:
            L.login(username, password)
            print("Login successful!")
        except Exception as e:
            print(f"Login failed: {e}. Continuing without login...")
    
    # Check if pre-filled data exists to blend into
    json_path = os.path.join(DATA_DIR, "clubs_data.json")
    clubs_data = []
    if os.path.exists(json_path):
        with open(json_path, 'r', encoding='utf-8') as f:
            try:
                clubs_data = json.load(f)
            except json.JSONDecodeError:
                pass
                
    for username in CLUB_USERNAMES:
        print(f"\nScraping {username}...")
        try:
            profile = instaloader.Profile.from_username(L.context, username)
            
            # Download profile picture
            avatar_path = download_image(
                profile.profile_pic_url, 
                os.path.join(AVATARS_DIR, f"{username}_avatar.jpg")
            )
            
            print(f"Followers: {profile.followers}")
            print(f"Bio: {profile.biography[:50]}...")
            
            # Fetch recent posts (limit to 5)
            posts = []
            count = 0
            for post in profile.get_posts():
                if count >= 5:
                    break
                    
                post_path = None
                if not post.is_video:
                    post_path = download_image(
                        post.url,
                        os.path.join(POSTS_DIR, f"{username}_post_{count}.jpg")
                    )
                
                posts.append({
                    "id": post.shortcode,
                    "imageUrl": f"assets/club_posts/{username}_post_{count}.jpg" if post_path else post.url,
                    "caption": post.caption if post.caption else "",
                    "likesCount": post.likes,
                    "postedAt": post.date_utc.isoformat(),
                    "isEvent": "register" in (post.caption or "").lower() or "link in bio" in (post.caption or "").lower()
                })
                count += 1
                
            # Update existing data if available, otherwise create new
            existing_club = next((c for c in clubs_data if c.get("instagramId") == username), None)
            
            if existing_club:
                existing_club["bio"] = profile.biography
                existing_club["followersCount"] = profile.followers
                if avatar_path:
                    existing_club["logoUrl"] = f"assets/club_avatars/{username}_avatar.jpg"
                existing_club["recentPosts"] = posts
            else:
                clubs_data.append({
                    "id": f"club_{username}",
                    "name": profile.full_name or username,
                    "instagramId": username,
                    "category": "Technology",
                    "bio": profile.biography,
                    "followersCount": profile.followers,
                    "memberCount": 150,
                    "logoUrl": f"assets/club_avatars/{username}_avatar.jpg" if avatar_path else "",
                    "coverUrl": "",
                    "collegeId": "c_dypcoe",
                    "collegeName": "DYPCOE",
                    "recentPosts": posts
                })
                
            print(f"Successfully scraped {username}!")
            
        except Exception as e:
            print(f"Error scraping {username}: {e}")
            
    # Save merged data
    with open(json_path, 'w', encoding='utf-8') as f:
        json.dump(clubs_data, f, indent=2, ensure_ascii=False)
        
    print(f"\nAll done! Data saved to {json_path}")

if __name__ == "__main__":
    main()
