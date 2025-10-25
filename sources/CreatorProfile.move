module sui_cut::creator_profile {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::transfer::{Self, public_transfer};
    use sui::sui::SUI;

    /// Creator profile object
    public struct CreatorProfile has key {
        id: UID,
        /// Name of the creator
        name: vector<u8>,
        /// Bio/description of the creator
        bio: vector<u8>,
        /// Balance of earnings from royalties
        earnings: Balance<Coin<SUI>>
    }

    /// Register a new creator
    public entry fun register_creator(
        name: vector<u8>,
        bio: vector<u8>,
        ctx: &mut TxContext
    ): CreatorProfile {
        CreatorProfile {
            id: object::new(ctx),
            name,
            bio,
            earnings: balance::zero()
        }
    }

    /// Update creator profile information
    public entry fun update_profile(
        profile: &mut CreatorProfile,
        new_name: vector<u8>,
        new_bio: vector<u8>
    ) {
        profile.name = new_name;
        profile.bio = new_bio;
    }

    /// Withdraw earnings from the creator's balance
    public entry fun withdraw_earnings(
        profile: &mut CreatorProfile,
        amount: u64,
        ctx: &mut TxContext
    ): Coin<SUI> {
        coin::take(&mut profile.earnings, amount, ctx)
    }

    /// Add earnings to the creator's balance
    public fun add_earnings(profile: &mut CreatorProfile, coin: Coin<SUI>) {
        let coin_balance = coin::into_balance(coin);
        balance::join(&mut profile.earnings, coin_balance);
    }

    /// Get total earnings balance
    public fun get_total_earnings(profile: &CreatorProfile): u64 {
        balance::value(&profile.earnings)
    }

    /// Get creator's name
    public fun get_name(profile: &CreatorProfile): &vector<u8> {
        &profile.name
    }

    /// Get creator's bio
    public fun get_bio(profile: &CreatorProfile): &vector<u8> {
        &profile.bio
    }

    /// Get the ID of the profile
    public fun id(profile: &CreatorProfile): &UID {
        &profile.id
    }
}