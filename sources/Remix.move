module sui_cut::remix {
    use std::option::{Self, Option};
    use sui::object::{Self, UID, ID};
    use sui::tx_context::{Self, TxContext};
    use sui::vec_map::{Self, VecMap};
    use sui_cut::video::{Self, Video};

    /// Tracks remix relationships between videos
    public struct RemixLineage has key {
        id: UID,
        /// Maps video IDs to their parent video IDs
        remix_tree: VecMap<ID, ID>
    }

    /// Tracks which creators are associated with remixes for royalty purposes
    public struct RemixCreators has key {
        id: UID,
        /// Maps video IDs to the original creator addresses
        creator_map: VecMap<ID, address>
    }

    /// Create a new remix lineage tracker
    public entry fun create_remix_lineage_tracker(ctx: &mut TxContext): RemixLineage {
        RemixLineage {
            id: object::new(ctx),
            remix_tree: vec_map::empty()
        }
    }

    /// Create a new remix creators tracker
    public entry fun create_remix_creators_tracker(ctx: &mut TxContext): RemixCreators {
        RemixCreators {
            id: object::new(ctx),
            creator_map: vec_map::empty()
        }
    }

    /// Create a remix relationship between parent and new video
    public entry fun create_remix(
        lineage: &mut RemixLineage,
        creators: &mut RemixCreators,
        parent_video: &Video,
        new_video: &Video,
        ctx: &mut TxContext
    ) {
        // Record the remix relationship
        vec_map::insert(&mut lineage.remix_tree, object::id(&new_video.id), object::id(&parent_video.id));
        
        // Record the original creator for royalty purposes
        vec_map::insert(&mut creators.creator_map, object::id(&new_video.id), video::get_creator(parent_video));
    }

    /// Get the parent video ID of a remix (if it exists)
    public fun get_parent_video(lineage: &RemixLineage, video_id: ID): Option<ID> {
        if (vec_map::contains(&lineage.remix_tree, &video_id)) {
            option::some(*vec_map::get(&lineage.remix_tree, &video_id))
        } else {
            option::none()
        }
    }

    /// Get the original creator of a remix (if it exists)
    public fun get_original_creator(creators: &RemixCreators, video_id: ID): Option<address> {
        if (vec_map::contains(&creators.creator_map, &video_id)) {
            option::some(*vec_map::get(&creators.creator_map, &video_id))
        } else {
            option::none()
        }
    }

    /// Get the complete remix lineage for a video
    public fun get_remix_lineage(lineage: &RemixLineage, video_id: ID): vector<ID> {
        let mut lineage_trace = vector[];
        let mut current_id = video_id;
        
        while (vec_map::contains(&lineage.remix_tree, &current_id)) {
            let parent_id = *vec_map::get(&lineage.remix_tree, &current_id);
            lineage_trace.push_back(parent_id);
            current_id = parent_id;
        };
        
        lineage_trace
    }
}