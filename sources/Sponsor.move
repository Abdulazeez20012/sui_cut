module sui_cut::sponsor {
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};

    /// Sponsor registry for SuiCut transactions
    public struct SuiCutSponsor has key {
        id: UID
    }

    /// Register a new sponsor for SuiCut transactions
    public entry fun register_sponsor(ctx: &mut TxContext): SuiCutSponsor {
        SuiCutSponsor {
            id: object::new(ctx)
        }
    }

    /// Get the ID of the sponsor
    public fun id(sponsor: &SuiCutSponsor): &UID {
        &sponsor.id
    }
}