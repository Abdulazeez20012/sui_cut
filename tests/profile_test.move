module sui_cut::profile_test {
    use std::signer;
    use sui::test_scenario::{Self, Scenario};
    use sui::tx_context::{Self, TxContext};
    use sui_cut::creator_profile::{Self, CreatorProfile};

    #[test]
    fun test_register_creator() {
        let mut ctx = tx_context::dummy();
        let name = b"Test Creator";
        let bio = b"A test creator for SuiCut";
        
        let profile = creator_profile::register_creator(name, bio, &mut ctx);
        
        assert!(*creator_profile::get_name(&profile) == name, 0);
        assert!(*creator_profile::get_bio(&profile) == bio, 0);
        assert!(creator_profile::get_total_earnings(&profile) == 0, 0);
    }

    #[test]
    fun test_update_profile() {
        let mut ctx = tx_context::dummy();
        let name = b"Original Name";
        let bio = b"Original bio";
        
        let mut profile = creator_profile::register_creator(name, bio, &mut ctx);
        
        let new_name = b"Updated Name";
        let new_bio = b"Updated bio";
        
        creator_profile::update_profile(&mut profile, new_name, new_bio);
        
        assert!(*creator_profile::get_name(&profile) == new_name, 0);
        assert!(*creator_profile::get_bio(&profile) == new_bio, 0);
    }

    #[test]
    fun test_earnings_management() {
        let mut ctx = tx_context::dummy();
        let name = b"Test Creator";
        let bio = b"A test creator";
        
        let mut profile = creator_profile::register_creator(name, bio, &mut ctx);
        
        // Test initial earnings
        assert!(creator_profile::get_total_earnings(&profile) == 0, 0);
    }
}