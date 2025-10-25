module sui_cut::video_test {
    use std::signer;
    use sui::test_scenario::{Self, Scenario};
    use sui::tx_context::{Self, TxContext};
    use sui_cut::video::{Self, Video};

    #[test]
    fun test_mint_video() {
        let mut ctx = tx_context::dummy();
        let creator = @0x1;
        let title = b"Test Video";
        let cid = b"test_cid_123";
        let royalty_bps = 1000; // 10%

        let video = video::mint_video(creator, title, cid, royalty_bps, &mut ctx);
        
        assert!(video::get_creator(&video) == creator, 0);
        assert!(*video::get_title(&video) == title, 0);
        assert!(*video::get_walrus_cid(&video) == cid, 0);
        assert!(video::get_royalty_bps(&video) == royalty_bps, 0);
        assert!(option::is_none(video::get_remix_origin(&video)), 0);
    }

    #[test]
    fun test_mint_remix_video() {
        let mut ctx = tx_context::dummy();
        let creator = @0x1;
        let original_creator = @0x2;
        let title = b"Remix Video";
        let cid = b"remix_cid_456";
        let royalty_bps = 2000; // 20%

        let video = video::mint_remix_video(creator, title, cid, royalty_bps, original_creator, &mut ctx);
        
        assert!(video::get_creator(&video) == creator, 0);
        assert!(*video::get_title(&video) == title, 0);
        assert!(*video::get_walrus_cid(&video) == cid, 0);
        assert!(video::get_royalty_bps(&video) == royalty_bps, 0);
        assert!(option::is_some(video::get_remix_origin(&video)), 0);
        assert!(option::borrow(video::get_remix_origin(&video)) == &original_creator, 0);
    }

    #[test]
    #[expected_failure(abort_code = 0)]
    fun test_mint_video_invalid_royalty() {
        let mut ctx = tx_context::dummy();
        let creator = @0x1;
        let title = b"Test Video";
        let cid = b"test_cid_123";
        let royalty_bps = 6000; // 60% - exceeds maximum

        video::mint_video(creator, title, cid, royalty_bps, &mut ctx);
    }

    #[test]
    fun test_update_video() {
        let mut ctx = tx_context::dummy();
        let creator = @0x1;
        let title = b"Original Title";
        let cid = b"original_cid";
        let royalty_bps = 1000; // 10%

        let mut video = video::mint_video(creator, title, cid, royalty_bps, &mut ctx);
        
        let new_title = b"Updated Title";
        let new_cid = b"updated_cid";
        let new_royalty_bps = 1500; // 15%
        
        video::update_video(&mut video, new_title, new_cid, new_royalty_bps);
        
        assert!(*video::get_title(&video) == new_title, 0);
        assert!(*video::get_walrus_cid(&video) == new_cid, 0);
        assert!(video::get_royalty_bps(&video) == new_royalty_bps, 0);
    }

    #[test]
    #[expected_failure(abort_code = 0)]
    fun test_update_video_invalid_royalty() {
        let mut ctx = tx_context::dummy();
        let creator = @0x1;
        let title = b"Test Video";
        let cid = b"test_cid_123";
        let royalty_bps = 1000; // 10%

        let mut video = video::mint_video(creator, title, cid, royalty_bps, &mut ctx);
        
        let new_title = b"Updated Title";
        let new_cid = b"updated_cid";
        let invalid_royalty_bps = 6000; // 60% - exceeds maximum
        
        video::update_video(&mut video, new_title, new_cid, invalid_royalty_bps);
    }
}