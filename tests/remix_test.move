module sui_cut::remix_test {
    use std::signer;
    use sui::test_scenario::{Self, Scenario};
    use sui::tx_context::{Self, TxContext};
    use sui_cut::remix::{Self, RemixLineage, RemixCreators};
    use sui_cut::video::{Self, Video};

    #[test]
    fun test_create_remix_lineage_tracker() {
        let mut ctx = tx_context::dummy();
        
        let _lineage = remix::create_remix_lineage_tracker(&mut ctx);
        // Successfully created if no panic
    }

    #[test]
    fun test_create_remix_creators_tracker() {
        let mut ctx = tx_context::dummy();
        
        let _creators = remix::create_remix_creators_tracker(&mut ctx);
        // Successfully created if no panic
    }

    #[test]
    fun test_remix_lineage() {
        let mut ctx = tx_context::dummy();
        let creator1 = @0x1;
        let creator2 = @0x2;
        
        let mut lineage = remix::create_remix_lineage_tracker(&mut ctx);
        let mut creators = remix::create_remix_creators_tracker(&mut ctx);
        
        // Create original video
        let original_title = b"Original Video";
        let original_cid = b"original_cid";
        let original_royalty = 1000; // 10%
        let original_video = video::mint_video(creator1, original_title, original_cid, original_royalty, &mut ctx);
        
        // Create remix video
        let remix_title = b"Remix Video";
        let remix_cid = b"remix_cid";
        let remix_royalty = 2000; // 20%
        let remix_video = video::mint_remix_video(creator2, remix_title, remix_cid, remix_royalty, creator1, &mut ctx);
        
        // Create remix relationship
        remix::create_remix(&mut lineage, &mut creators, &original_video, &remix_video, &mut ctx);
        
        // Test getting parent video
        let parent_option = remix::get_parent_video(&lineage, object::id(&remix_video.id));
        assert!(option::is_some(&parent_option), 0);
        assert!(*option::borrow(&parent_option) == object::id(&original_video.id), 0);
        
        // Test getting original creator
        let creator_option = remix::get_original_creator(&creators, object::id(&remix_video.id));
        assert!(option::is_some(&creator_option), 0);
        assert!(*option::borrow(&creator_option) == creator1, 0);
    }

    #[test]
    fun test_get_remix_lineage() {
        let mut ctx = tx_context::dummy();
        let creator1 = @0x1;
        let creator2 = @0x2;
        let creator3 = @0x3;
        
        let mut lineage = remix::create_remix_lineage_tracker(&mut ctx);
        let mut creators = remix::create_remix_creators_tracker(&mut ctx);
        
        // Create original video
        let original_title = b"Original Video";
        let original_cid = b"original_cid";
        let original_royalty = 1000;
        let original_video = video::mint_video(creator1, original_title, original_cid, original_royalty, &mut ctx);
        
        // Create first remix
        let remix1_title = b"First Remix";
        let remix1_cid = b"remix1_cid";
        let remix1_royalty = 2000;
        let remix1_video = video::mint_remix_video(creator2, remix1_title, remix1_cid, remix1_royalty, creator1, &mut ctx);
        
        // Create second remix (remix of remix)
        let remix2_title = b"Second Remix";
        let remix2_cid = b"remix2_cid";
        let remix2_royalty = 1500;
        let remix2_video = video::mint_remix_video(creator3, remix2_title, remix2_cid, remix2_royalty, creator2, &mut ctx);
        
        // Create remix relationships
        remix::create_remix(&mut lineage, &mut creators, &original_video, &remix1_video, &mut ctx);
        remix::create_remix(&mut lineage, &mut creators, &remix1_video, &remix2_video, &mut ctx);
        
        // Test lineage trace
        let lineage_trace = remix::get_remix_lineage(&lineage, object::id(&remix2_video.id));
        assert!(vector::length(&lineage_trace) == 2, 0);
    }
}