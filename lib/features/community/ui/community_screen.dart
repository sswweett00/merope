import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../domain/models/community_model.dart';
import '../logic/community_logic.dart';
import 'widgets/community_card.dart';
import 'widgets/event_card.dart';
import 'widgets/collective_card.dart';
import 'widgets/thread_card.dart';
import 'widgets/member_list_item.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Communities'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateCommunityDialog(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Discover'),
            Tab(text: 'My Communities'),
            Tab(text: 'Events'),
            Tab(text: 'Collectives'),
            Tab(text: 'Subscriptions'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildDiscoverTab(),
          _buildMyCommunitiesTab(),
          _buildEventsTab(),
          _buildCollectivesTab(),
          _buildSubscriptionsTab(),
        ],
      ),
    );
  }

  Widget _buildDiscoverTab() {
    final communitiesAsync = ref.watch(communityControllerProvider);

    return communitiesAsync.when(
      data: (communities) => ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: communities.length,
        itemBuilder: (context, index) {
          return CommunityCard(
            community: communities[index],
            onTap: () => _navigateToCommunityDetail(communities[index].id),
            onJoin: () => ref
                .read(communityControllerProvider.notifier)
                .join(communities[index].id),
          );
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildMyCommunitiesTab() {
    final communitiesAsync = ref.watch(communityControllerProvider);

    return communitiesAsync.when(
      data: (communities) {
        final myCommunities = communities.where((c) => c.isJoined).toList();
        if (myCommunities.isEmpty) {
          return const Center(child: Text('No communities joined yet'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: myCommunities.length,
          itemBuilder: (context, index) {
            return CommunityCard(
              community: myCommunities[index],
              onTap: () => _navigateToCommunityDetail(myCommunities[index].id),
              onLeave: () => ref
                  .read(communityControllerProvider.notifier)
                  .leave(myCommunities[index].id),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildEventsTab() {
    final eventsAsync = ref.watch(eventControllerProvider);

    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('No upcoming events'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventCard(
              event: events[index],
              onRsvp: (status) => ref
                  .read(eventControllerProvider.notifier)
                  .rsvp(events[index].id, status),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildCollectivesTab() {
    final collectivesAsync = ref.watch(collectiveControllerProvider);

    return collectivesAsync.when(
      data: (collectives) {
        if (collectives.isEmpty) {
          return const Center(child: Text('No collectives available'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: collectives.length,
          itemBuilder: (context, index) {
            return CollectiveCard(
              collective: collectives[index],
              onTap: () => _navigateToCollective(collectives[index].id),
              onJoin: () => ref
                  .read(collectiveControllerProvider.notifier)
                  .joinCollective(collectives[index].id),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildSubscriptionsTab() {
    final subscriptionsAsync = ref.watch(subscriptionControllerProvider);

    return subscriptionsAsync.when(
      data: (subscriptions) {
        if (subscriptions.isEmpty) {
          return const Center(child: Text('No active subscriptions'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: subscriptions.length,
          itemBuilder: (context, index) {
            return _buildSubscriptionCard(subscriptions[index]);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildSubscriptionCard(Subscription subscription) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(child: Text(subscription.tier[0].toUpperCase())),
        title: Text('Subscription to ${subscription.creatorId}'),
        subtitle: Text(
            '${subscription.tier} - ${subscription.currency} ${subscription.amount.toStringAsFixed(2)}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(subscription.status.name),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.cancel),
              onPressed: () => ref
                  .read(subscriptionControllerProvider.notifier)
                  .cancelSubscription(subscription.id),
            ),
          ],
        ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Communities'),
        content: TextField(
          autofocus: true,
          decoration:
              const InputDecoration(hintText: 'Enter community name...'),
          onSubmitted: (value) {
            ref.read(communityControllerProvider.notifier).search(value);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showCreateCommunityDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Community'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Community Name'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                final newCommunity = Community(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  ownerId: 'me',
                  name: nameController.text,
                  slug: nameController.text.toLowerCase().replaceAll(' ', '-'),
                  description: descController.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  settings: const CommunitySettings(),
                  stats: const CommunityStats(),
                  isJoined: true,
                  userRole: CommunityRole.owner,
                );
                ref
                    .read(communityControllerProvider.notifier)
                    .createCommunity(newCommunity);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _navigateToCommunityDetail(String communityId) {
    context.go('/community/$communityId');
  }

  void _navigateToCollective(String collectiveId) {
    context.go('/collective/$collectiveId');
  }
}

class CommunityDetailScreen extends ConsumerWidget {
  final String communityId;

  const CommunityDetailScreen({super.key, required this.communityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityAsync = ref.watch(communityDetailControllerProvider);
    final eventsAsync = ref.watch(eventControllerProvider);
    final membersAsync = ref.watch(memberControllerProvider);
    final analyticsAsync = ref.watch(analyticsControllerProvider);

    // Set the community ID when the widget builds
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(communityDetailControllerProvider.notifier)
          .setCommunityId(communityId);
      ref.read(eventControllerProvider.notifier).setCommunityId(communityId);
      ref.read(memberControllerProvider.notifier).setCommunityId(communityId);
      ref
          .read(analyticsControllerProvider.notifier)
          .setCommunityId(communityId);
    });

    return Scaffold(
      appBar: AppBar(
        title: communityAsync.when(
          data: (community) => Text(community?.name ?? 'Community'),
          loading: () => const Text('Loading...'),
          error: (_, __) => const Text('Error'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showSettingsDialog(context, ref),
          ),
        ],
      ),
      body: DefaultTabController(
        length: 5,
        child: Column(
          children: [
            _buildCommunityHeader(communityAsync, analyticsAsync),
            const TabBar(
              isScrollable: true,
              tabs: [
                Tab(text: 'Posts'),
                Tab(text: 'Events'),
                Tab(text: 'Members'),
                Tab(text: 'Proposals'),
                Tab(text: 'Analytics'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPostsTab(),
                  _buildEventsTab(eventsAsync),
                  _buildMembersTab(membersAsync),
                  _buildProposalsTab(),
                  _buildAnalyticsTab(analyticsAsync),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityHeader(AsyncValue<Community?> communityAsync,
      AsyncValue<CommunityAnalytics?> analyticsAsync) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          communityAsync.when(
            data: (community) => Text(
              community?.description ?? '',
              style: const TextStyle(fontSize: 14),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16),
          analyticsAsync.when(
            data: (analytics) => analytics != null
                ? Row(
                    children: [
                      _buildStatCard(
                          'Members', analytics.memberCount.toString()),
                      const SizedBox(width: 12),
                      _buildStatCard('Posts', analytics.postCount.toString()),
                      const SizedBox(width: 12),
                      _buildStatCard('Events', analytics.eventCount.toString()),
                    ],
                  )
                : const SizedBox.shrink(),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
              Text(label, style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPostsTab() {
    return const Center(child: Text('Posts will be displayed here'));
  }

  Widget _buildEventsTab(AsyncValue<List<CommunityEvent>> eventsAsync) {
    return eventsAsync.when(
      data: (events) {
        if (events.isEmpty) {
          return const Center(child: Text('No events scheduled'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: events.length,
          itemBuilder: (context, index) {
            return EventCard(
              event: events[index],
              onRsvp: (status) {},
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildMembersTab(AsyncValue<List<CommunityMember>> membersAsync) {
    return membersAsync.when(
      data: (members) {
        if (members.isEmpty) {
          return const Center(child: Text('No members'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: members.length,
          itemBuilder: (context, index) {
            return MemberListItem(
              member: members[index],
              onPromote: (role) {},
              onBan: (reason) {},
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAnalyticsTab(AsyncValue<CommunityAnalytics?> analyticsAsync) {
    return analyticsAsync.when(
      data: (analytics) {
        if (analytics == null) {
          return const Center(child: Text('No analytics data available'));
        }
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Community Analytics',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              _buildAnalyticsCard('Engagement Rate',
                  '${analytics.engagementRate.toStringAsFixed(2)}%'),
              _buildAnalyticsCard('Avg Session Time',
                  '${analytics.avgSessionTime.toStringAsFixed(1)} min'),
              _buildAnalyticsCard(
                  'New Members', analytics.newMembers.toString()),
              _buildAnalyticsCard(
                  'Active Members', analytics.activeMembers.toString()),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildAnalyticsCard(String label, String value) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(label),
        trailing:
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildProposalsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _ProposalSection(title: 'Active Votes', proposals: [
          _ProposalData(
              title: 'Increase Minimum Reputation',
              status: 'ACTIVE',
              yes: 45,
              no: 5,
              weight: 1.5),
        ]),
        const SizedBox(height: 24),
        _ProposalSection(title: 'Discussion (Drafts)', proposals: [
          _ProposalData(
              title: 'Enable Biometric Vaults',
              status: 'DRAFT',
              yes: 0,
              no: 0,
              weight: 0.0),
        ]),
        const SizedBox(height: 24),
        _ProposalSection(title: 'Passed (Finalized)', proposals: [
          _ProposalData(
              title: 'Implement Neural Sync V5',
              status: 'PASSED',
              yes: 120,
              no: 2,
              weight: 2.0),
        ]),
      ],
    );
  }

  void _showSettingsDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Community Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Voice Chat'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Video Chat'),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Screen Share'),
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _ProposalSection extends StatelessWidget {
  final String title;
  final List<_ProposalData> proposals;
  const _ProposalSection({required this.title, required this.proposals});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w900,
                color: Colors.grey,
                letterSpacing: 1)),
        const SizedBox(height: 12),
        ...proposals.map((p) => _ProposalCard(data: p)),
      ],
    );
  }
}

class _ProposalData {
  final String title;
  final String status;
  final int yes;
  final int no;
  final double weight;
  _ProposalData(
      {required this.title,
      required this.status,
      required this.yes,
      required this.no,
      required this.weight});
}

class _ProposalCard extends StatelessWidget {
  final _ProposalData data;

  const _ProposalCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final total = data.yes + data.no;
    final percent = total > 0 ? data.yes / total : 0.0;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Text(data.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold))),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color:
                          _getStatusColor(data.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4)),
                  child: Text(data.status,
                      style: TextStyle(
                          color: _getStatusColor(data.status),
                          fontSize: 9,
                          fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (data.status != 'DRAFT') ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percent,
                  minHeight: 6,
                  backgroundColor: Colors.red.withValues(alpha: 0.2),
                  valueColor:
                      AlwaysStoppedAnimation(_getStatusColor(data.status)),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${data.yes} YES',
                      style: const TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                  Text('${data.no} NO',
                      style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ],
              ),
            ] else
              const Text('In pre-vote discussion period...',
                  style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey)),
            const Divider(height: 24),
            Row(
              children: [
                const Icon(Icons.token_outlined, size: 14, color: Colors.amber),
                const SizedBox(width: 8),
                Text('YOUR STAKED WEIGHT: ${data.weight}x',
                    style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber)),
                const Spacer(),
                if (data.status == 'ACTIVE')
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16)),
                    child: const Text('VOTE',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'ACTIVE') return Colors.green;
    if (status == 'PASSED') return Colors.blue;
    return Colors.grey;
  }
}

class CollectiveDetailScreen extends ConsumerWidget {
  final String collectiveId;

  const CollectiveDetailScreen({super.key, required this.collectiveId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.read(threadControllerProvider.notifier).setCollectiveId(collectiveId);
    final threadsAsync = ref.watch(threadControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collective Threads'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateThreadDialog(context, ref),
          ),
        ],
      ),
      body: threadsAsync.when(
        data: (threads) {
          if (threads.isEmpty) {
            return const Center(child: Text('No threads yet'));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: threads.length,
            itemBuilder: (context, index) {
              return ThreadCard(
                thread: threads[index],
                onResonate: (isPositive) => ref
                    .read(threadControllerProvider.notifier)
                    .resonate(threads[index].id, isPositive),
                onReply: () =>
                    _showReplyDialog(context, ref, threads[index].id),
                onPin: () => ref
                    .read(threadControllerProvider.notifier)
                    .pinThread(threads[index].id, !threads[index].isPinned),
                onLock: () => ref
                    .read(threadControllerProvider.notifier)
                    .lockThread(threads[index].id, !threads[index].isLocked),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  void _showCreateThreadDialog(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    final contentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Thread'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: contentController,
              decoration: const InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.isNotEmpty) {
                final thread = CollectiveThread(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  collectiveId: 'default',
                  title: titleController.text,
                  content: contentController.text,
                  authorId: 'me',
                  authorName: 'You',
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  resonance: 0,
                  viewCount: 0,
                  replyCount: 0,
                  isPinned: false,
                  isLocked: false,
                  isAnnouncement: false,
                  tags: [],
                  category: 'general',
                );
                ref
                    .read(threadControllerProvider.notifier)
                    .createThread(thread);
                Navigator.pop(context);
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showReplyDialog(BuildContext context, WidgetRef ref, String threadId) {
    final replyController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reply to Thread'),
        content: TextField(
          controller: replyController,
          decoration: const InputDecoration(labelText: 'Your reply'),
          maxLines: 5,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (replyController.text.isNotEmpty) {
                final reply = ThreadReply(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  threadId: threadId,
                  authorId: 'me',
                  authorName: 'You',
                  content: replyController.text,
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  isEdited: false,
                );
                ref
                    .read(threadControllerProvider.notifier)
                    .replyToThread(reply);
                Navigator.pop(context);
              }
            },
            child: const Text('Reply'),
          ),
        ],
      ),
    );
  }
}
