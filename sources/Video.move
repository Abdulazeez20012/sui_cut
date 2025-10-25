module sui_cut::Video {
    use std::option::{Self, Option};
    use sui::object::{Self, UID};
    use sui::tx_context::{Self, TxContext};
    // Add missing transfer module
    use sui::transfer;

    /// Maximum royalty percentage (50% in basis points)
    const MAX_ROYALTY_BPS: u64 = 5000;

    /// Video object representing a video on the platform
    struct Video has key {
        id: UID,
        /// Address of the creator
        creator: address,
        /// Content ID of the video stored on Walrus
        walrus_cid: vector<u8>,
        /// Title of the video
        title: vector<u8>,
        /// Royalty percentage in basis points (0-5000 for 0-50%)
        royalty_bps: u64,
        /// Original creator if this is a remix
        remix_origin: Option<address>
    }

    /// Create a new video object
    public entry fun mint_video(
        creator: address,
        title: vector<u8>,
        cid: vector<u8>,
        royalty_bps: u64,
        ctx: &mut TxContext
    ): Video {
        assert!(royalty_bps <= MAX_ROYALTY_BPS, EInvalidRoyalty);
        Video {
            id: object::new(ctx),
            creator,
            walrus_cid: cid,
            title,
            royalty_bps,
            remix_origin: option::none()
        }
    }

    /// Create a remix video with reference to the original creator
    public entry fun mint_remix_video(
        creator: address,
        title: vector<u8>,
        cid: vector<u8>,
        royalty_bps: u64,
        original_creator: address,
        ctx: &mut TxContext
    ): Video {
        assert!(royalty_bps <= MAX_ROYALTY_BPS, EInvalidRoyalty);
        Video {
            id: object::new(ctx),
            creator,
            walrus_cid: cid,
            title,
            royalty_bps,
            remix_origin: option::some(original_creator)
        }
    }

    /// Update video metadata
    public entry fun update_video(
        video: &mut Video,
        new_title: vector<u8>,
        new_cid: vector<u8>,
        new_royalty_bps: u64
    ) {
        assert!(new_royalty_bps <= MAX_ROYALTY_BPS, EInvalidRoyalty);
        video.title = new_title;
        video.walrus_cid = new_cid;
        video.royalty_bps = new_royalty_bps;
    }

    /// Transfer video ownership to another address
    public entry fun transfer_video(video: Video, recipient: address, ctx: &mut TxContext) {
        let Video { id, creator: _, walrus_cid, title, royalty_bps, remix_origin } = video;
        let new_video = Video {
            id,
            creator: recipient,
            walrus_cid,
            title,
            royalty_bps,
            remix_origin
        };
        transfer::public_transfer(new_video, recipient, ctx);
    }

    /// Delete a video object
    public entry fun delete_video(video: Video) {
        let Video { id, creator: _, walrus_cid: _, title: _, royalty_bps: _, remix_origin: _ } = video;
        id.delete();
    }

    /// Get the creator of the video
    public fun get_creator(video: &Video): address {
        video.creator
    }

    /// Get the Walrus CID of the video
    public fun get_walrus_cid(video: &Video): &vector<u8> {
        &video.walrus_cid
    }

    /// Get the title of the video
    public fun get_title(video: &Video): &vector<u8> {
        &video.title
    }

    /// Get the royalty percentage in basis points
    public fun get_royalty_bps(video: &Video): u64 {
        video.royalty_bps
    }

    /// Check if the video is a remix and get the original creator
    public fun get_remix_origin(video: &Video): &Option<address> {
        &video.remix_origin
    }

    /// Get the ID of the video
    public fun id(video: &Video): UID {
        video.id
    }

    // Error codes
    const EInvalidRoyalty: u64 = 0;
}