import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bss_api/bloc/overlay_bloc.dart';
import 'package:flutter_bss_api/models/user.dart';
import 'package:flutter_bss_api/utils/matches.dart';
import 'package:fluttery_dart2/layout.dart';


class CardStackUser extends StatefulWidget {
  final MatchEngine matchEngine;

  CardStackUser({this.matchEngine});

  @override
  _CardStackUserState createState() => _CardStackUserState();
}

class _CardStackUserState extends State<CardStackUser> {
  Key _frontCard;
  Match _currentMatch;
  double _nextCardScale = 0.0;

  @override
  void initState() {
    super.initState();
    widget.matchEngine.addListener(_onMatchEngineChange);

    _currentMatch = widget.matchEngine.currentMatch;
    _currentMatch.addListener(_onMatchChange);

    _frontCard = new Key(_currentMatch.user.gender);
  }

  @override
  void didUpdateWidget(CardStackUser oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);

      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }

    widget.matchEngine.removeListener(_onMatchEngineChange);
    super.dispose();
  }

  _onMatchEngineChange() {
    setState(() {
      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }

      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }

      _frontCard = new Key(_currentMatch.user.gender);
    });
  }

  _onMatchChange() {
    setState(() {});
  }

  Widget _buildBackCard() {
    return Transform(
      transform: Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: ProfileCard(
        profile: widget.matchEngine.nextMatch.user,
      ),
    );
  }

  Widget _buildFrontCard() {
    return ProfileCard(
      key: _frontCard,
      profile: widget.matchEngine.currentMatch.user,
    );
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.nope:
        return SlideDirection.left;
        break;
      case Decision.like:
        return SlideDirection.right;
        break;
      case Decision.superLike:
        return SlideDirection.up;
        break;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideComplete(SlideDirection direction) {
    Match currenMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currenMatch.like();
        break;
      case SlideDirection.right:
        currenMatch.nope();
        break;
      case SlideDirection.up:
        currenMatch.superLike();
        break;
    }

    widget.matchEngine.cycleMatch();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        DraggableCard(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          isDraggable: false,
          card: _buildBackCard(),
        ),
        DraggableCard(
          screenHeight: MediaQuery.of(context).size.height,
          screenWidth: MediaQuery.of(context).size.width,
          card: _buildFrontCard(),
          slideTo: _desiredSlideOutDirection(),
          onSlideUpdate: _onSlideUpdate,
          onSlideComplete: _onSlideComplete,
        )
      ],
    );
  }
}

enum SlideDirection {
  left,
  right,
  up,
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideComplete;
  final double screenWidth;
  final double screenHeight;

  DraggableCard({
    Key key,
    this.card,
    this.isDraggable = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideComplete,
    this.screenWidth,
    this.screenHeight,
  });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> with TickerProviderStateMixin {
  Decision decision;
  GlobalKey profileCardKey = GlobalKey(debugLabel: 'profile_card_key');
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPosition;
  Offset slideBackStart;
  SlideDirection slideOutDirection;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;

  @override
  void initState() {
    super.initState();
    slideBackAnimation = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )
      ..addListener(() => setState(() {
            cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
                Curves.elasticOut.transform(slideBackAnimation.value));

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            slideBackStart = null;
            dragPosition = null;
          });
        }
      });

    slideOutAnimation = new AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )
      ..addListener(() => setState(() {
            cardOffset = slideOutTween.evaluate(slideOutAnimation);

            if (null != widget.onSlideUpdate) {
              widget.onSlideUpdate(cardOffset.distance);
            }
          }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPosition = null;
            slideOutTween = null;

            if (widget.onSlideComplete != null) {
              widget.onSlideComplete(slideOutDirection);
            }
          });
        }
      });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        case SlideDirection.up:
          _slideUp();
          break;
      }
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    slideOutAnimation.dispose();
    super.dispose();
  }

  void _slideLeft() {
    // final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(-2 * widget.screenWidth, 0.0),
    );


    slideOutAnimation.forward(from: 0.0);
  }

  Offset _chooseRandomDragStart() {
    final cardContext = profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY =
        widget.screenHeight * (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
            cardTopLeft.dy;

    return Offset(widget.screenWidth / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideRight() {
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(2 * widget.screenWidth, 0.0),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _slideUp() {
    // final screenHeight = context.size.height;
    dragStart = _chooseRandomDragStart();
    slideOutTween = Tween(
      begin: const Offset(0.0, 0.0),
      end: Offset(0.0, -2 * widget.screenHeight),
    );

    slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPosition = details.globalPosition;
      cardOffset = dragPosition - dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInLeftRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInRightRegion = (cardOffset.dx / context.size.width) > 0.45;
    final isInTopRegion = (cardOffset.dy / context.size.height) < -0.40;

    setState(() {
      if (isInLeftRegion || isInRightRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));

        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
            isInLeftRegion ? SlideDirection.left : SlideDirection.right;
      } else if (isInTopRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.height));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection = SlideDirection.up;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  double _rotation(Rect dragBounds) {
    if (dragStart != null) {
      final rotationCornerMultiplier =
          dragStart.dy >= dragBounds.top + (dragBounds.height / 2) ? -1 : 1;
      return (pi / 8) *
          (cardOffset.dx / dragBounds.width) *
          rotationCornerMultiplier;
    } else {
      return 0.0;
    }
  }

  Offset _rotationOrigin(Rect dragBounds) {
    if (dragStart != null) {
      return dragStart - dragBounds.topLeft;
    } else {
      return const Offset(0.0, 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: overlayBloc.overlayStream,
      initialData: true,
      builder: (context, value){
        return new AnchoredOverlay(
          showOverlay: value.data,
          child: new Center(),
          overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor) {
            return CenterAbout(
              position: anchor,
              child: new Transform(
                transform:
                new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
                  ..rotateZ(_rotation(anchorBounds)),
                origin: _rotationOrigin(anchorBounds),
                child: new Container(
                  key: profileCardKey,
                  width: anchorBounds.width,
                  height: anchorBounds.height,
                  padding: const EdgeInsets.all(16.0),
                  child: new GestureDetector(
                    onPanStart: _onPanStart,
                    onPanUpdate: _onPanUpdate,
                    onPanEnd: _onPanEnd,
                    child: widget.card,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProfileCard extends StatefulWidget {
  final User profile;

  ProfileCard({Key key, this.profile}) : super(key: key);

  @override
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {

  String _content, label;
  bool first = true;


  Widget _buildProfile(){
    return Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 370,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Container(
                          width: 160,
                          height: 160,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.grey),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(widget.profile.picture.large)
                                  )
                              ),
                            ),
                          ),
                        ),
                      ),
                      Text(
                        '$label',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 5,),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            checkFirst(first, widget.profile),
                            style: TextStyle(fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Column(
                        children: <Widget>[
                          _buildTopIndicator(),
                          Container(
                            margin: EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    //_buildTopIndicator(false),
                                    IconButton(
                                      icon: Image(image: AssetImage('assets/icons/ic_user_default.png'),),
                                      onPressed:() {
                                        setState(() {
                                          label = 'My name is';
                                          _content = '${widget.profile.name.title}.${widget.profile.name.first} ${widget.profile.name.last}';
                                          first = false;
                                          checkFirst(first, widget.profile);
                                          //_content = setupContent(result, 0);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    //_buildTopIndicator(false),
                                    IconButton(
                                      icon: Image(image: AssetImage('assets/icons/ic_schedule_default.png'),),
                                      onPressed: () {
                                        setState(() {
                                          label = 'My schedule is';
                                          _content = '${widget.profile.location.street.number} ${widget.profile.location.street.name},${widget.profile.location.city},${widget.profile.location.state}';
                                          //setupContent(result, 1);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    //_buildTopIndicator(true),
                                    IconButton(
                                      icon: Image(image: AssetImage('assets/icons/ic_map_selected.png'),),
                                      onPressed: (){
                                        setState(() {
                                          label = 'My address is';
                                          _content = '${widget.profile.location.street.number} ${widget.profile.location.street.name},${widget.profile.location.city},${widget.profile.location.state}';
                                          //setupContent(result, 2);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    //_buildTopIndicator(false),
                                    IconButton(
                                      icon: Image(image: AssetImage('assets/icons/ic_phone_default.png'),),
                                      onPressed: (){
                                        setState(() {
                                          label = 'My phone is';
                                          _content = '${widget.profile.phone}';
                                          //setupContent(result, 3);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Column(
                                  children: <Widget>[
                                    //_buildTopIndicator(false),
                                    IconButton(
                                      icon: Image(image: AssetImage('assets/icons/ic_privacy_default.png'),),
                                      onPressed: (){
                                        setState(() {
                                          label = 'My password is';
                                          _content = '${widget.profile.login.password}';
                                          //setupContent(result, 4);
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                )
              ],
            ),
          );
  }

  Widget _buildTopIndicator(){
    /*if(value){*/
    return Container(
      width: 200,
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AnimatedPositioned(
              duration: Duration(milliseconds: 300),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                      margin: EdgeInsets.only(bottom: 2),
                      child: Image(image: AssetImage('assets/icons/ic_up_arrow.png'), width: 10, height: 10,)),
                  Container(
                    width: 30,
                    height: 2,
                    color: Colors.green[700],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
    //}
    /*else{
      return Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 10,
                margin: EdgeInsets.only(bottom: 2),
                *//*child: Image(image: AssetImage('assets/icons/ic_up_arrow.png'), width: 10, height: 10,)*//*
            ),
            Container(
              width: 30,
              height: 2,
              color: Colors.white,
            ),
          ],
        ),
      );
    }*/

  }

  Widget _buildProfileCard(){
    return GestureDetector(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    width: double.infinity,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                        color: Colors.grey[200]
                    ),
                  ),
                  Container(
                    height: 2,
                    width: double.infinity,
                    color: Colors.grey,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  String checkFirst(bool value, User result){
    if(value){
      return '${result.location.street},${result.location.city},${result.location.state}';
    }
    else{
      return _content;
    }
  }

  void changeColorIcon(int position){

    switch(position){
      case 0:

    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          borderRadius: new BorderRadius.circular(10.0),
          boxShadow: [
            new BoxShadow(
              color: const Color(0x11000000),
              blurRadius: 5.0,
              spreadRadius: 2.0,
            )
          ]),
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(10.0),
        child: new Material(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              //_buildBackground(),
              _buildProfileCard(),
              _buildProfile(),
            ],
          ),
        ),
      ),
    );
  }
}
