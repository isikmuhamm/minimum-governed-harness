// ContextRail: TASK-0001
// Invariant: Read-only handling does not modify specification state.
export function testReadOnlyMutationGuard(): void {
  const canMutate = false;
  if (canMutate) throw new Error('read-only handling mutated specification state');
}
