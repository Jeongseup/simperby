use super::*;
use raw::RawCommit;
use simperby_network::Error;
use simperby_network::*;

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct PayloadCommit {
    pub commit: RawCommit,
    pub hash: CommitHash,
    pub parent_hash: CommitHash,
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub enum BranchType {
    Agenda,
    AgendaProof,
    Block,
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub struct PayloadBranch {
    pub branch_type: BranchType,
    /// The list of commit hashes in the branch, starting from
    /// **the next commit** of the `finalized` commit.
    pub commit_hashes: Vec<CommitHash>,
}

#[derive(Clone, Debug, PartialEq, Eq, Serialize, Deserialize)]
pub enum RepositoryMessage {
    Commit(PayloadCommit),
    Branch(PayloadBranch),
}

impl ToHash256 for RepositoryMessage {
    fn to_hash256(&self) -> Hash256 {
        Hash256::hash(serde_spb::to_vec(self).unwrap())
    }
}

impl DmsMessage for RepositoryMessage {
    const DMS_TAG: &'static str = "repository";

    fn check(&self) -> Result<(), Error> {
        Ok(())
    }
}
