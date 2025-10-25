module sui_cut::CreatorProfile {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    use sui::balance::{Self, Balance};
    use sui::coin::{Self, Coin};
    use sui::transfer;
    use sui::zklogin_verified_id::{Self, ZkLoginVerifiedId};

    /// Creator profile object
    struct CreatorProfile has key {
        id: UID,
        /// Verified zkLogin identity of the creator
        identity: ZkLoginVerifiedId,
        /// Name of the creator
        name: vector<u8>,
        /// Bio/description of the creator
        bio: vector<u8>,
        /// Balance of earnings from royalties
        earnings: Balance<Coin<SUI>>
    }

    /// Register a new creator with zkLogin verification
    public entry fun register_creator(
        identity: ZkLoginVerifiedId,
        name: vector<u8>,
        bio: vector<u8>,
        ctx: &mut TxContext
    ): CreatorProfile {
        CreatorProfile {
            id: object::new(ctx),
            identity,
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
        balance::join(&mut profile.earnings, coin::into_balance(coin));
    }

    /// Get total earnings balance
    public fun get_total_earnings(profile: &CreatorProfile): u64 {
        balance::value(&profile.earnings)
    }

    /// Get creator's zkLogin identity
    public fun get_identity(profile: &CreatorProfile): &ZkLoginVerifiedId {
        &profile.identity
    }

    /// Get creator's name
    public fun get_name(profile: &CreatorProfile): &vector<u8> {
        &profile.name
    }

    /// Get creator's bio
    public fun get_bio(profile: &CreatorProfile): &vector<u8> {
        &profile.bio
    }
}