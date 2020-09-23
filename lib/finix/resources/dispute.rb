module Finix
  class Dispute
    include Finix::Resource
    include Finix::HypermediaRegistry

    define_hypermedia_types [:disputes]

    def upload_evidence(evidence_file_path)
      self.evidence.create :file => Faraday::UploadIO.new(evidence_file_path, 'application/octet-stream')
    end
  end
end
