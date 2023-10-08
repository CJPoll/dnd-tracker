defprotocol DndTracker.Entity.Component do
  def allows_multiple?(component)
  def name(component)
end
