module sui_cut::sponsor_test {
    use std::signer;
    use sui::test_scenario::{Self, Scenario};
    use sui::tx_context::{Self, TxContext};
    use sui_cut::sponsor::{Self, SuiCutSponsor};

    #[test]
    fun test_register_sponsor() {
        let mut ctx = tx_context::dummy();
        
        let sponsor = sponsor::register_sponsor(&mut ctx);
        
        // Successfully created if no panic
    }
}