import os

replacements = {
    "package:pagebridge/feature/databases/data/data_source/recent_pages_remote_data_source.dart": "package:pagebridge/feature/pages/data/data_source/recent_pages_remote_data_source.dart",
    "package:pagebridge/feature/databases/data/model/page_model.dart": "package:pagebridge/feature/pages/data/model/page_model.dart",
    "package:pagebridge/feature/databases/data/repos/recent_pages_repo_impl.dart": "package:pagebridge/feature/pages/data/repos/recent_pages_repo_impl.dart",
    "package:pagebridge/feature/databases/domain/entities/page_entity.dart": "package:pagebridge/feature/pages/domain/entities/page_entity.dart",
    "package:pagebridge/feature/databases/domain/repo/recent_pages_repo.dart": "package:pagebridge/feature/pages/domain/repo/recent_pages_repo.dart",
    "package:pagebridge/feature/databases/presentation/controllers/recent_pages_cubit/recent_pages_cubit.dart": "package:pagebridge/feature/pages/presentation/controllers/recent_pages_cubit/recent_pages_cubit.dart",
    "package:pagebridge/feature/databases/presentation/controllers/recent_pages_cubit/recent_pages_state.dart": "package:pagebridge/feature/pages/presentation/controllers/recent_pages_cubit/recent_pages_state.dart",
    "package:pagebridge/feature/databases/presentation/views/recent_pages_feed.dart": "package:pagebridge/feature/pages/presentation/views/recent_pages_feed.dart",
    "package:pagebridge/feature/databases/presentation/widgets/custom_skeletonizer_recent_page.dart": "package:pagebridge/feature/pages/presentation/widgets/custom_skeletonizer_recent_page.dart",
    "package:pagebridge/feature/databases/presentation/widgets/recent_page_card.dart": "package:pagebridge/feature/pages/presentation/widgets/recent_page_card.dart",
    "package:pagebridge/feature/databases/presentation/widgets/recent_pages_feed_body.dart": "package:pagebridge/feature/pages/presentation/widgets/recent_pages_feed_body.dart",
    "package:pagebridge/feature/databases/presentation/widgets/recent_pages_list.dart": "package:pagebridge/feature/pages/presentation/widgets/recent_pages_list.dart",
    
    "package:pagebridge/feature/add_new_page/data/data_source/return_pages_remote_data_source.dart": "package:pagebridge/feature/pages/data/data_source/return_pages_remote_data_source.dart",
    "package:pagebridge/feature/add_new_page/data/repos/return_pages_repo_impl.dart": "package:pagebridge/feature/pages/data/repos/return_pages_repo_impl.dart",
    "package:pagebridge/feature/add_new_page/domain/repo/return_pages_repo.dart": "package:pagebridge/feature/pages/domain/repo/return_pages_repo.dart",
    "package:pagebridge/feature/add_new_page/presentation/controllers/return_pages_cubit/return_pages_cubit.dart": "package:pagebridge/feature/pages/presentation/controllers/return_pages_cubit/return_pages_cubit.dart",
    
    "package:pagebridge/feature/databases/presentation/widgets/custom_floating_action_button.dart": "package:pagebridge/core/helpers/custom_floating_action_button.dart",
    "package:pagebridge/feature/databases/presentation/widgets/home_app_bar.dart": "package:pagebridge/core/helpers/home_app_bar.dart",
}

def process_file(filepath):
    with open(filepath, 'r') as f:
        content = f.read()
    
    new_content = content
    for old, new in replacements.items():
        new_content = new_content.replace(old, new)
        
    if new_content != content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        print(f"Updated {filepath}")

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            process_file(os.path.join(root, file))
