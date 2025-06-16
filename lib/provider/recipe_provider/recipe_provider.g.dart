// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recipeRepoHash() => r'444aee617e2e71dea54d99f662ed840d7c4d623a';

/// See also [recipeRepo].
@ProviderFor(recipeRepo)
final recipeRepoProvider = AutoDisposeProvider<RecipeRepo>.internal(
  recipeRepo,
  name: r'recipeRepoProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$recipeRepoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef RecipeRepoRef = AutoDisposeProviderRef<RecipeRepo>;
String _$recipeNotifierHash() => r'853a88466fe9ddd93c10fc966e41e9aedeb2d2df';

/// See also [RecipeNotifier].
@ProviderFor(RecipeNotifier)
final recipeNotifierProvider =
    AutoDisposeAsyncNotifierProvider<RecipeNotifier, RecipeResponse?>.internal(
      RecipeNotifier.new,
      name: r'recipeNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$recipeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$RecipeNotifier = AutoDisposeAsyncNotifier<RecipeResponse?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
