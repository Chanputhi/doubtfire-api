class LearningOutcomeTaskLink < ActiveRecord::Base
  belongs_to :task_definition
  belongs_to :task
  belongs_to :learning_outcome

  validates :task_definition, presence: true
  validates :learning_outcome, presence: true
  validate :ensure_relations_unique

  def ensure_relations_unique
    return if learning_outcome.nil? || task_definition.nil?
    
    related_links = LearningOutcomeTaskLink.where( "task_definition_id = :task_definition_id AND learning_outcome_id = :learning_outcome_id", {task_definition_id: task_definition.id, learning_outcome_id: learning_outcome.id} )
    if task.nil?
      errors.add(:task_definition, "already linked to the learning outcome") if related_links.where("task_id is NULL").count > 1
    else
      errors.add(:task, "already linked to the learning outcome") if related_links.where("task_id = :task_id", {task_id: task.id}).count > 1
    end
  end
end
