module sui_cut::royalty_test {
    use std::signer;
    use sui::test_scenario::{Self, Scenario};
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui_cut::royalty::{Self, Royalty};
    use sui_cut::video::{Self, Video};
    use sui::sui::SUI;

    #[test]
    fun test_calculate_royalty() {
        let amount = 10000; // 10000 units
        let bps = 1000; // 10%
        let expected_royalty = 1000; // 10% of 10000
        
        let calculated_royalty = royalty::calculate_royalty(amount, bps);
        assert!(calculated_royalty == expected_royalty, 0);
    }

    #[test]
    fun test_calculate_royalty_zero() {
        let amount = 10000; // 10000 units
        let bps = 0; // 0%
        let expected_royalty = 0; // 0% of 10000
        
        let calculated_royalty = royalty::calculate_royalty(amount, bps);
        assert!(calculated_royalty == expected_royalty, 0);
    }

    #[test]
    fun test_calculate_royalty_max() {
        let amount = 10000; // 10000 units
        let bps = 5000; // 50%
        let expected_royalty = 5000; // 50% of 10000
        
        let calculated_royalty = royalty::calculate_royalty(amount, bps);
        assert!(calculated_royalty == expected_royalty, 0);
    }

    #[test]
    fun test_get_royalty_percentage() {
        let bps = 1000; // 1000 basis points
        let expected_percentage = 10; // 10%
        
        let percentage = royalty::get_royalty_percentage(bps);
        assert!(percentage == expected_percentage, 0);
    }
}