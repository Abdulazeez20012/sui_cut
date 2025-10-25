module sui_cut::Royalty {
    use std::option::{Self, Option};
    use sui::object::UID;
    use sui::tx_context::{Self, TxContext};
    use sui::coin::{Self, Coin};
    use sui_cut::Video::{Self, Video};
    // Import SUI type
    use sui::sui::SUI;

    /// Calculate royalty amount based on basis points
    public fun calculate_royalty(amount: u64, bps: u64): u64 {
        (amount * bps) / 10000
    }

    /// Distribute royalty to a single creator
    public fun distribute_royalty_single(
        video: &Video,
        amount: Coin<SUI>,
        _ctx: &mut TxContext
    ): Coin<SUI> {
        let royalty_amount = calculate_royalty(coin::value(&amount), Video::get_royalty_bps(video));
        let _remaining_amount = coin::value(&amount) - royalty_amount;
        
        // For now, we'll just return the original amount
        // In a real implementation, we would split and distribute
        amount
    }

    /// Distribute royalty with support for multi-level remix royalties
    public fun distribute_royalty_with_remix(
        video: &Video,
        amount: Coin<SUI>,
        _ctx: &mut TxContext
    ): Coin<SUI> {
        let total_amount = coin::value(&amount);
        let royalty_bps = Video::get_royalty_bps(video);
        let royalty_amount = calculate_royalty(total_amount, royalty_bps);
        
        // If this is a remix, split royalty between original and remix creator
        if (option::is_some(Video::get_remix_origin(video))) {
            // Split royalty 50-50 between original and remix creator for simplicity
            let remix_royalty = royalty_amount / 2;
            let _original_royalty = royalty_amount - remix_royalty;
            
            // In a real implementation, we would transfer to both creators' profiles
            // For now, we'll just return the original amount
            amount
        } else {
            // Single creator royalty
            amount
        }
    }

    /// Helper function to get royalty percentage as a readable value
    public fun get_royalty_percentage(bps: u64): u64 {
        bps / 100
    }
}