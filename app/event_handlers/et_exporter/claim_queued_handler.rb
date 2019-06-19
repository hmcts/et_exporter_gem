module EtExporter
  class ClaimQueuedHandler
    def handle(claim, system)
      ExportClaimWorker.perform_async(claim, system) if ExportClaimWorker.queue_exists_for?(system)
    end
  end
  
  class ExportClaimWorker
    include Sidekiq::Worker
    
    def self.perform_async(claim, system)
      client_push('class' => '::EtExporter::ExportClaimWorker', 'args' => [claim.id, system.id], 'queue' => system.export_queue)
    end
    
    def perform
    
    end
    
    def self.queue_exists_for?(system)
      return true
      Sidekiq.redis {|redis| redis.sismember('queues', system.export_queue)}
    end
    
  end
end
